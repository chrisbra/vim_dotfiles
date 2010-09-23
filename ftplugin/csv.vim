" Filetype plugin for editing CSV files.
" From http://vim.wikia.com/wiki/VimTip667
if v:version < 700 || exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Display a warning message.
function! s:Warn(msg)
  echohl WarningMsg
  echo a:msg
  echohl NONE
endfunction

" Get the number of columns (maximum of number in first and last three
" lines; at least one of them should contain typical csv data).
function! s:GetNumCols()
  let b:csv_max_col = 1
  for l in [1, 2, 3, line('$') - 2, line('$') - 1, line('$')]
    " Determine number of columns by counting the (unescaped) commas.
    " Note: The regexp may also return unbalanced ", so filter out anything
    " which isn't a comma in the second pass.
    let c = strlen(substitute(substitute(getline(l), '\%(\%("\%([^"]\|""\)*"\)\|\%([^,"]*\)\)', '', 'g'), '"', '', 'g')) + 1
    if b:csv_max_col < c
      let b:csv_max_col = c
    endif
  endfor
  if b:csv_max_col <= 1
    let b:csv_max_col = 10000
    call s:Warn("No comma-separated columns were detected.")
  endif
  return b:csv_max_col
endfunction

" Return regex to find the n-th column.
function! s:GetExpr(colnr, ...)
  if a:0 == 0  " field only
    let field = '\%(\%("\zs\%([^"]\|""\)*\ze"\)\|\%(\zs[^,"]*\ze\)\)'
  else  " field with quotes (if present) and trailing comma (if present)
    let field = '\%(\%(\zs"\%([^"]\|""\)*",\?\ze\)\|\%(\zs[^,"]*,\?\ze\)\)'
  endif
  if a:colnr > 1
    return '^\%(\%(\%("\%([^"]\|""\)*"\)\|\%([^,"]*\)\),\)\{' . (a:colnr - 1) . '}' . field
  else
    return '^' . field
  endif
endfunction

" Extract and echo the column header on the status line.
function! s:PrintColInfo(colnr)
  let colHeading = substitute(matchstr(getline(1), s:GetExpr(a:colnr)), '^\s*\(.*\)\s*$', '\1', '')
  let info = 'Column ' . a:colnr
  if empty(colHeading)
    echo info
  else
    echon info . ': '
    echohl Type
    " Limit length to avoid "Hit ENTER" prompt.
    echon strpart(colHeading, 0, (&columns / 2)) . (len(colHeading) > (&columns / 2) ? "..." : "")
    echohl NONE
  endif
endfunction

" Highlight n-th column (if n > 0).
" Remove previous highlight match (ignore error if none).
" matchadd() priority -1 means 'hlsearch' will override the match.
function! s:Highlight(colnr)
  silent! call matchdelete(b:csv_match)
  if a:colnr > 0
    if exists('*matchadd')
      let b:csv_match = matchadd("Keyword", s:GetExpr(a:colnr), -1)
    else
      execute '2match Keyword /' . s:GetExpr(a:colnr) . '/'
    endif
    if b:changed_done != b:changedtick
      let b:changed_done = b:changedtick
      call s:GetNumCols()
    endif
    call s:Focus_Col(a:colnr)
  endif
endfunction

" Focus the cursor on the n-th column of the current line.
function! s:Focus_Col(colnr)
  normal! 0
  call search(s:GetExpr(a:colnr), '', line('.'))
  call s:PrintColInfo(a:colnr)
endfunction

" Highlight next column.
function! s:HighlightNextCol()
  if b:csv_column < b:csv_max_col
    let b:csv_column += 1
  endif
  call s:Highlight(b:csv_column)
endfunction

" Highlight previous column.
function! s:HighlightPrevCol()
  if b:csv_column > 1
    let b:csv_column -= 1
  endif
  call s:Highlight(b:csv_column)
endfunction

" Wrapping would distort the column-based layout.
" Lines must not be broken when typed.
setlocal nowrap textwidth=0
" Undo the stuff we changed.
let b:undo_ftplugin = "setlocal wrap< textwidth<"
    \ . "|if exists('*matchdelete')|call matchdelete(b:csv_match)|else|2match none|endif"
    \ . "|sil! exe 'nunmap <buffer> H'"
    \ . "|sil! exe 'nunmap <buffer> L'"
    \ . "|sil! exe 'nunmap <buffer> J'"
    \ . "|sil! exe 'nunmap <buffer> K'"
    \ . "|sil! exe 'nunmap <buffer> <C-f>'"
    \ . "|sil! exe 'nunmap <buffer> <C-b>'"
    \ . "|sil! exe 'nunmap <buffer> 0'"
    \ . "|sil! exe 'nunmap <buffer> $'"
    \ . "|sil exe 'augroup csv' . bufnr('')"
    \ . "|sil exe 'au!'"
    \ . "|sil exe 'augroup END'"

let b:changed_done = -1
" Highlight the first column, but not if reloading or resetting filetype.
if !exists('b:csv_column')
  let b:csv_column = 1
endif
" Following highlights column and calls GetNumCols() if set filetype manually
" (BufEnter will also do it if filetype is set during load).
silent call s:Highlight(b:csv_column)

" Compare two lines based on the highlighted column.
function! s:CompareLines(line1, line2)
  let col1 = matchstr(a:line1, s:GetExpr(b:csv_column_sort))
  let col2 = matchstr(a:line2, s:GetExpr(b:csv_column_sort))
  return col1 > col2
endfunction

" Sort the n-th column, the highlighted one by default.
function! s:SortCol(colnr)
  if a:colnr == ""
    let b:csv_column_sort = b:csv_column
  else
    let b:csv_column_sort = str2nr(a:colnr)
  endif
  if b:csv_column_sort < 1 || b:csv_column_sort > b:csv_max_col
    call s:Warn("column number out of range.")
  endif
  call setline(2, sort(getline(2, '$'), function("s:CompareLines")))
endfunction
command! -buffer -nargs=? Sort execute <SID>SortCol("<args>")

" Delete the n-th column, the highlighted one by default.
function! s:DeleteCol(colnr)
  if a:colnr == ""
    let col = b:csv_column
  else
    let col = str2nr(a:colnr)
  endif
  if col < 1 || col > b:csv_max_col
    call s:Warn("column number out of range.")
  endif
  exec '%s/'.s:GetExpr(col, 1).'//'
  if col == b:csv_max_col
    silent %s/,$//e
  endif
  let b:csv_max_col -= 1
  if b:csv_column > b:csv_max_col
    call s:HighlightPrevCol()
  endif
endfunction
command! -buffer -nargs=? DC execute <SID>DeleteCol("<args>")

" Search the n-th column. Argument in n=regex form where n is the column
" number, and regex is the expression to use. If "n=" is omitted, then
" use the current highlighted column.
function! s:SearchCol(colexp)
  let regex = '\%(\([1-9][0-9]*\)=\)\?\(.*\)'
  let colstr = substitute(a:colexp, regex, '\1', '')
  let target = substitute(a:colexp, regex, '\2', '')
  if colstr == ""
    let col = b:csv_column
  else
    let col = str2nr(substitute(a:colexp, '=.*', '', ''))
    if col < 1 || col > b:csv_max_col
      call s:Warn("column number out of range")
    endif
  endif
  if col == 1
    let @/ = '^\%(\%("\%([^,]\|""\)*\zs'.target.'\ze\%([^,]\|""\)*"\)\|\%([^,"]*\zs'.target.'\ze[^,"]*\)\)'
  else
    let @/ = '^\%(\%(\%("\%([^"]\|""\)*"\)\|\%([^,"]*\)\),\)\{' . (col-1) . '}\%(\%("\%([^,]\|""\)*\zs'.target.'\ze\%([^,]\|""\)*"\)\|\%([^,"]*\zs'.target.'\ze[^,"]*\)\)'
  endif
endfunction
" Use :SC n=string<CR> to search for string in the n-th column
command! -buffer -nargs=1 SC execute <SID>SearchCol("<args>")|normal! n
nnoremap <silent> <buffer> H :call <SID>HighlightPrevCol()<CR>
nnoremap <silent> <buffer> L :call <SID>HighlightNextCol()<CR>
nnoremap <silent> <buffer> J <Down>:call <SID>Focus_Col(b:csv_column)<CR>
nnoremap <silent> <buffer> K <Up>:call <SID>Focus_Col(b:csv_column)<CR>
nnoremap <silent> <buffer> <C-f> <PageDown>:call <SID>Focus_Col(b:csv_column)<CR>
nnoremap <silent> <buffer> <C-b> <PageUp>:call <SID>Focus_Col(b:csv_column)<CR>
nnoremap <silent> <buffer> <C-d> <C-d>:call <SID>Focus_Col(b:csv_column)<CR>
nnoremap <silent> <buffer> <C-u> <C-u>:call <SID>Focus_Col(b:csv_column)<CR>
nnoremap <silent> <buffer> 0 :let b:csv_column=1<CR>:call <SID>Highlight(b:csv_column)<CR>
nnoremap <silent> <buffer> $ :let b:csv_column=b:csv_max_col<CR>:call <SID>Highlight(b:csv_column)<CR>
nnoremap <silent> <buffer> gm :call <SID>Focus_Col(b:csv_column)<CR>
nnoremap <silent> <buffer> <LocalLeader>J J
nnoremap <silent> <buffer> <LocalLeader>K K

" The column highlighting is window-local, not buffer-local, so it can persist
" even when the filetype is undone or the buffer changed.
execute 'augroup csv' . bufnr('')
  autocmd!
  " These events only highlight in the current window.
  " Note: Highlighting gets slightly confused if the same buffer is present in
  " two split windows next to each other, because then the events aren't fired.
  autocmd BufLeave <buffer> silent call <SID>Highlight(0)
  autocmd BufEnter <buffer> silent call <SID>Highlight(b:csv_column)
augroup END

