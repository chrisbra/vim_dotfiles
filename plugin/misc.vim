" Misc: {{{1
" Init: {{{2
let s:cpo= &cpo
if exists("g:loaded_misc_plugin") || &cp
  finish
endif
set cpo&vim
let g:loaded_misc_plugin = 1

" Define the actual Commands "{{{2
com! Scriptnames	:call misc#List('scriptnames')
com! Oldfiles		:call misc#List('oldfiles')

" C-L should also clear search highlighting "{{{2
nnoremap <silent> <c-l> <c-l>:nohls<cr>

" Make certain keys in insert mode undoable "{{{2
" make <BS> <DEL> <C-U> and <C-W> undoable
" h i_Ctrl-g_u
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
inoremap <BS> <C-G>u<BS>
inoremap <DEL> <C-G>u<DEL>
" let i_Ctrl-R be undoable (should also be redoable with '.')
inoremap <c-r> <c-g>u<c-r>

" Ex-Command aliased "{{{2
" You are too fast and keep pressing `shift' if you type :w, try following
":command! -bang W w<bang>
command! -bang -bar -nargs=? -complete=file -range=% W  <line1>,<line2>w<bang> <args>
command! -bang Wq wq<bang>
command! -bang Q q<bang>

" Autocommands "{{{2
" if 'eaqualalways' is set, this should also taken into account, when Resizing
" Vim
au VimResized * if &ea | wincmd = |endif

" Cscope

command! -nargs=+ Csfind call Csfind("cscope", <f-args>) 

function! Csfind(cmd, querytype, name) 
	try 
		execute a:cmd "find" a:querytype  a:name 
		return 
	catch /E567/                    " 'no cscope connections' 
		" Continue after endtry. 
	catch /.*/                      " Any other error. 
		call s:EchoException() 
		return 
	endtry 
	try 
		if exists("g:cscope_prepend_path") 
			execute "cs add" g:cscope_database g:cscope_prepend_path 
		elseif exists("g:cscope_database")
			execute "cs add" g:cscope_database 
		else
			" try to find a cscope.out file
				let cscopefile = findfile("cscope.out", ".;")
				if empty(cscopefile)
					throw "No Cscope database found!"
				else
					exe "cs add" cscopefile
				endif
		endif 
	catch /.*/ 
		" Note:  The perror() message 
		"    cs_read_prompt EOF: Error 0 
		" currently (2004-02-20) hides the more-informative message 
		"    E609: Cscope error: cscope: cannot read file version from file cscope.out 
		" 
		call s:EchoException() 
		return 
	endtry 
	try 
		execute a:cmd "find" a:querytype  a:name 
	catch /.*/                      " Any error. 
		call s:EchoException() 
	endtry 
endfunction 

function! s:EchoException() 
	if &errorbells 
		normal \<Esc>               " Generate a bell 
	endif 
	echohl ErrorMsg 
	echo matchstr(v:exception, ':\zs.*') 
	echohl None 
endfunction 

hi link searchFound Search
hi link searchHigh  Error
hi searchRest guifg=#AAAAAA

" Ctrl-F in normal command issues a search, without moving the cursor.
function! s:search (str, opos, ...)
  let str = a:str
  echohl Type
  redraw
  echo "Searching for: "
  echohl None
  echon str
  let ch = getchar()
  for n in a:000
    if n >= 0
      call matchdelete(n)
    endif
  endfor
  " <Esc>: cancel the whole thing.
  if ch == 27
    call cursor(a:opos[1], a:opos[2])
  " Other chars, except <Enter>, which does nothing (the cursor is already
  " where it must be).
  elseif ch != 13
    if ch == "\<BackSpace>"
      let str = substitute(str, '.$', '', 'g')
    elseif ch != 9 " 9 is <Tab>.
      let str  .= nr2char(ch)
    end
    let rest  = matchadd('searchRest', '.*')
    let found = matchadd('searchFound', str)
    " <Tab> moves to the next match, <S-Tab> to the previous one.
    let f = ch == 9 ? '' : (ch == "\<S-Tab>" ? 'b' : 'c')
    let pos   = searchpos(str, f)
    call cursor(pos)
    let high  = matchadd('searchHigh', '\%' . pos[0] . 'l\%' . pos[1] .'c' . str)
    call s:search(str, a:opos, rest, found, high)
  endif
endfunction

nnoremap \<C-f> :call <SID>search('', getpos('.'))<CR>


" Restore: "{{{2
let &cpo=s:cpo
unlet s:cpo
" vim: ts=4 sts=4 fdm=marker com+=l\:\"
