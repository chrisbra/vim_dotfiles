"-------------------------------------------------------
" Vim Functions from 
" Christian Brabandt cb@256bit.org
"
" Last update: Fr 2014-05-16 20:53
" 
"-------------------------------------------------------

" DoubleQuote: inserts » or « instead of "
" Modified version of TexQuotes() by Benji Fisher <benji@e-math.AMS.org>
function! s:DoubleQuote() "{{{1
    let l = line(".")
    let c = col(".")
    let restore_cursor = l . "G" . virtcol(".") . "|"
    normal! H
    let restore_cursor = "normal!" . line(".") . "Gzt" . restore_cursor
    execute restore_cursor

    " Find the appropriate open-quote and close-quote strings.
    let open = "»"
    let close = "«"
    let boundary = '\|'

    " Eventually return q; set it to the default value now.
    let q = open
    let pattern = 
                \ escape(open, '\~') .
                \ boundary .
                \ escape(close, '\~') .
                \ '\|^$\|"'

    while 1     " Look for preceding quote (open or close)
        call search(pattern, "bw")
        if strpart(getline('.'), col('.')-2, 2) != '\"'
            break
        endif
    endwhile

    " Now, test whether we actually found a _preceding_ quote; if so, is it
    " an open quote?
    if ( line(".") < l || line(".") == l && col(".") < c )
        if strpart(getline("."), col(".")-1) =~ '\V\^' . escape(open, '\')
            let q = close
        endif
    endif

    " Return to line l, column c:
    execute restore_cursor
    " Start with <Del> to remove the " put in by the :imap .
    return "\<Del>" . q
endfunction
" inoremap <buffer> <silent> _" "<Left><C-R>=<SID>DoubleQuote()<CR>


" SingleQuote: insert . or . instead of '
function! s:SingleQuote() "{{{1
    let close = "."
    let open = "."
    let q = close
    if col(".") == 1 || strpart (getline("."), col(".")-2, 1) == ' '
        let q = open
    else
        let q = close
    endif
    return "\<Del>" . q
endfunction
"inoremap <buffer> <silent> _' "<Left><C-R>=<SID>SingleQuote()<CR>

" The Shell in a Box mode. 
" Requires zsh for "print -P $PS1" / replace if needed.
" Your prompt should end in > (and only contain one)

" map __start :imap <C-V><C-M> <C-O>__cmd<C-V>\|imap <C-V><ESC> <C-V><ESC>__end<C-M>
"noremap __end :iunmap <C-V><CR>\|iunmap <C-V><ESC><C-M>:"Vish ended.<C-M>
" For bash we substitue print -P $PS1 with echo 'vish> '
" noremap __cmd 0<ESC>f>ly$:r !<C-R>";print -P $PS1<C-M>A
" noremap __scmd :r !print -P $PS1<c-M>A
" noremap __cmd 0<ESC>f>ly$:r !<C-R>";echo 'vish> '<C-M>A
" noremap __scmd :r !echo 'vish> '<c-M>A
" map ,sh __start__scmd


"-------------------------------------------------------
" AUTOCOMMANDS
"-------------------------------------------------------

" Update .*rc header
fun! UpdateRcHeader() "{{{1
    let l:c=col(".")
    let l:l=line(".")
    if search("Last update:") != 0
        1,8s-\(Last update:\).*-\="Last update: ".strftime("%a %Y\-%m\-%d %R")-
    endif
    call cursor(l:l, l:c)
endfun

" Meine Autocommands
"augroup configs
    "autocmd!
     " Header von .vimrc und .bashrc automatisch updated
     "autocmd BufWritePre *vimrc  :call UpdateRcHeader()
     "autocmd BufWritePre *.vim  :call UpdateRcHeader()
     "autocmd BufWritePre *bashrc :call UpdateRcHeader()
     "autocmd BufWritePre */.mutt/* :call UpdateRcHeader()
     "autocmd BufWritePre muttrc :call UpdateRcHeader()
     "autocmd BufWritePre personal.vim :call UpdateRcHeader()
"augroup END

  function! MyTabLine() "{{{1
    let s = ''
    for i in range(tabpagenr('$'))
      " select the highlighting
      if i + 1 == tabpagenr()
        let s .= '%#TabLineSel#'
      else
        let s .= '%#TabLine#'
      endif

  "    " set the tab page number (for mouse clicks)
      let s .= '%' . (i + 1) . 'T'. ' '. (i+1). ' '

      " the label is made by MyTabLabel()
      let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
      let s .= '%=%#TabLine#%999Xclose'
    endif

    return s
  endfunction
        
function! MyTabLabel(n) "{{{1
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
return bufname(buflist[winnr - 1])
endfunction

function! CompileScript() "{{{1
    " the name of the current file
    let fname = expand('%')

    " can't compile unless the file is saved
    if &modified
      echo printf('Please save %s before compiling', fname)
      return
    endif

    " decide how to execute the script:
    if &filetype == 'perl'
      execute printf('!perl %s', fname)

    elseif &filetype == 'ruby'
      execute printf('!ruby %s', fname)

    elseif &filetype == 'bash' || &filetype == 'sh'
      execute printf('!source %s', fname)

    else
      echo printf("Don't know how to compile filetype '%s'", &filetype)
    endif

endfunction

fu! ToggleFoldByCurrentSearchPattern() "{{{1
  if !&foldenable
    set foldenable
    set foldmethod=expr
    set foldexpr=getline(v:lnum)!~@/
    norm! zM
    set foldmethod=manual
    echo "zR to open all folds; zo top open 1 fold; zc to close 1 fold"
  else
     set nofoldenable
  endif
endfu

" Insert the date in a certain format
function! InsertDate(format) "{{{1
  if ! exists('*strftime')
    echoerr 'strftime() not defined'
    return -1
  endif
  let f = a:format
  if f == ""
    let f = '%c'
  endif
  exe "normal a\<C-R>=strftime(" . '"' . f . '"' .  ")\e"
endfunction

" :Date will insert the current date and time in your
" locale-dependent default format; or
" :Date %d %b %Y
"  will (today) insert
"  14 Nov 2006
"
 command! -nargs=0 DiffOrig
  \| let g:ShowDifferencesOriginalBuffer=bufnr('%')
  \| let DiffFileType=&ft
  \| execute 'bufdo setlocal nodiff foldcolumn=0'
  \| execute 'buffer' g:ShowDifferencesOriginalBuffer
  \| diffthis
  \| below vert new
  \| let g:ShowDifferencesScratchWindow=winnr()
  \| set buftype=nofile noswapfile bufhidden=wipe
  \| let &ft=DiffFileType
  \| unlet DiffFileType
  \| r #
  \| 1d
  \| setlocal noma
  \| diffthis

 command! -nargs=0 NoDiffOrig
  \| let CurrentWinNr=winnr()
  \| execute g:ShowDifferencesScratchWindow 'wincmd w'
  \| setlocal nodiff foldcolumn=0
  \| close
  \| setlocal nodiff foldcolumn=0
  \| execute CurrentWinNr 'wincmd w'
  \| unlet CurrentWinNr

 func! ToggleDiffOrig() "{{{1
  if exists("g:DiffOriginal")
    NoDiffOrig
    unlet g:DiffOriginal
  else
    DiffOrig
    let g:DiffOriginal=1
  endif
 endfunc

fu! DiffUnified() "{{{1
  let diffexpr="diff -Nuar"
  let bname=bufname("")
  let origtemp=0
  " Case 1: File has a filename and is not modified
  if !&modified && !empty(bname)
    let tempfile=0
    let origFile=bname.".orig"
  else
  " Case 2: File has a filename and is modified
    if &modified && !empty(bname)
      if !filereadable(bname.".orig")
        sp 
        enew
        r #
        0d
        let tempfile2=tempname()
        exe ":sil w! " .tempfile2
        wincmd q
        let origtemp=1
        wincmd p
      endif
      let origFile=bname.".orig"
  " Case 3: File is new and is modified
    else
      if &modified
        let origFile=bname.".orig"
      else
        let origFile=""
      endif
    endif
    let bname=tempname()
    exe ":sil w! ".bname
    let tempfile=1
  endif
  try
    if !filereadable(origFile) 
      let origFile=input("With which file to diff?: ","","file")
    endif
    if !filereadable(bname)
      exe ":sil w! ".bname
    endif
    if empty(origFile)
      throw "nofile"
    endif
    exe "sil sp"
    exe "enew"
    set bt=nofile
    exe "sil r!".diffexpr." ".origFile." ".bname
    exe "0d_"
    exe "set ft=diff"
    " Clean up temporary files
    if  tempfile == 1
      exe "sil :!rm -f ". bname
      let tempfile=0
    endif
    if origtemp == 1
      exe "sil :!rm -f ". origFile
      let origtemp=0
    endif
  catch
  endtry
endf

command! MakePatch :call DiffUnified()

if has('user_commands')
  command! -nargs=0 WhatSyntax call WhatSyntax()
  command! -bar ShowSyntax :echo 'Normal '.join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'))
endif

fu! WhatSyntax() "{{{1
" show highlight groups under cursor with F10
  if exists(':for')
    echo "<" .
    \ synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name')
    \ .'> from:'
    let indent = ''
    for syn_id in synstack(line('.'), col('.'))
      echo indent.'<'.synIDattr(syn_id,"name").'>' 
      let indent .= ' '
    endfor
    unlet indent
  else
" can't do for loop, at least display something
    echo "hi<" . 
      \ synIDattr(synID(line("."),col("."),1),"name")
      \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
  endif
endfu

" RS will execute a search within a visually selected area
" mark the area with v and type :RS pattern
command! -nargs=* -range RS exe 'normal /\%>' . (<line1> - 1) . 'l\%<'. (<line2> + 1) . 'l<args><CR>'

command! -nargs=* -bar Date call InsertDate(<q-args>)

" -----------------------------------
" Chose a random color scheme each time
" this file is sourced
" -----------------------------------
"let mycolors = split(globpath(&rtp,"**/colors/*.vim"),"\n")
"exe 'so ' . mycolors[localtime() % len(mycolors)]
"unlet mycolors
"
function! CleverTab()  "{{{1
  if pumvisible() 
    return "\<C-N>" 
  endif 
  if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$' 
    return "\<Tab>" 
  elseif exists('&omnifunc') && &omnifunc != '' 
    return "\<C-X>\<C-O>" 
  else 
    return "\<Tab>" 
endif 
endfunction 
"inoremap <Tab> <C-R>=CleverTab()<CR> 

function! Info(cmd) "{{{1
  execute "new|r!info --subnodes --output - ". a:cmd
endfunction
com! -nargs=* Info call Info(<f-args>)

function! SpellLegend() "{{{1
  for [l:group, l:explanation] in [
  \   ['SpellBad', 'word not recognized'],
  \   ['SpellCap', 'word not capitalized'],
  \   ['SpellRare', 'rare word'],
  \   ['SpellLocal', 'wrong spelling for selected region']
  \]
    echo ''
    echon l:group . "\t"
    execute 'echohl' l:group
    echon 'xxx'
    echohl None
    echon "\t" . l:explanation
  endfor
endfunction
command! -bar SpellLegend call SpellLegend()

" command PP: print lines like :p or :# but with with current search pattern highlighted
function! PrintWithSearchHighlighted(line1,line2,arg) "{{{1
  let line=a:line1
  while line <= a:line2
    echo ""
    if a:arg =~ "#"
      echohl LineNr
      echo strpart(" ",0,7-strlen(line)).line."\t"
      echohl None
    endif
    let l=getline(line)
    let index=0
    while 1
      let b=match(l,@/,index)
      if b==-1
        echon strpart(l,index)
        break
      endif
      let e=matchend(l,@/,index)
      if e == b
        let e += 1
      endif
      echon strpart(l,index,b-index)
      echohl Search
      echon strpart(l,b,e-b)
      echohl None
      let index = e
    endw
    let line=line+1
  endw
endfunction
command! -nargs=? -range -bar PP :call PrintWithSearchHighlighted(<line1>,<line2>,<q-args>)

function! ShowOldfiles(mods, filter) "{{{1
  let i=1
  let length=len(v:oldfiles)
  if length < 1 
    echo "no oldfiles available"
    return
  endif
  for val in v:oldfiles
    if val =~? a:filter
      echon printf("%*d) ", strlen(length), i)
      if !empty(a:filter)
        let [start, end] = [match(val, a:filter), matchend(val, a:filter)]
        echon strpart(val, 0, start)
        echohl WarningMsg
        echon strpart(val, start, end-start)
        echohl Normal
        echon strpart(val, end)."\n"
      else
        echon val."\n"
      endif
      "echo printf("%*d) %s", strlen(length), i, val)
    endif
    let i+=1
  endfor
  let input=input('Enter number of file to open: ')
  if empty(input)
      return
  elseif input !~? '^\d\+' || input > length
      echo "invalid number selected, aborting..."
  else
      exe a:mods ":e " v:oldfiles[input-1]
  endif
endfu
com! -nargs=? Oldfiles :call ShowOldfiles(<q-mods>, <q-args>)

