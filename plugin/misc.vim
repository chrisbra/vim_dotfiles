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
com! LastChange     :echo " start: ".string(getpos("'["))." end: ".string(getpos("']"))

" C-L should also clear search highlighting "{{{2
if maparg("<c-l>", 'n') == ''
  nnoremap <silent> <c-l> <c-l>:nohls<cr>
endif

" Make certain keys in insert mode undoable "{{{2
" make <BS> <DEL> <C-U> and <C-W> undoable
" h i_Ctrl-g_u
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
"inoremap <BS> <C-G>u<BS>
"inoremap <DEL> <C-G>u<DEL>
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
"au VimResized * if &ea | wincmd = |endif

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
					throw "E:No Cscope database found!"
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

"Examples:
":Page version
":Page messages
":Page ls
"It also works with the :!cmd command and Ex special characters like % (cmdline-special)
":Page !wc %
"Capture and return the long output of a verbose command.
function! s:Redir(cmd)
	let output = ""
	redir =>> output
	silent exe a:cmd
	redir END
	" remove first blank line
	return output[1:]
endfunction
 
"A command to open a scratch buffer.
function! s:Scratch()
	split Scratch
	setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
	return bufnr("%")
endfunction
 
"Put the output of acommand into a scratch buffer.
function! s:Page(command)
	let output = s:Redir(a:command)
	call s:Scratch()
	normal gg
	call append(1, split(output, "\n"))
endfunction
 
command! -nargs=+ -complete=command Page :call <SID>Page(<q-args>)

" CursorLineNr should change color in gui mode
call misc#CursorLineNrAdjustment()

" Highlight search term {{{2
" http://vi.stackexchange.com/q/2761

" Disabled for now, does not work as wanted:
if 0
  fun! SearchHighlight()
	  silent! call matchdelete(b:ring)
	  let b:ring = matchadd('ErrorMsg', '\c\%#' . @/, 101)
  endfun

  fun! SearchNext()
	  try
		  execute 'normal! ' . 'Nn'[v:searchforward]
	  catch /E385:/
		  echohl ErrorMsg | echo "E385: search hit BOTTOM without match for: " . @/ | echohl None
	  endtry
	  call SearchHighlight()
  endfun

  fun! SearchPrev()
	  try
		  execute 'normal! ' . 'nN'[v:searchforward]
	  catch /E384:/
		  echohl ErrorMsg | echo "E384: search hit TOP without match for: " . @/ | echohl None
	  endtry
	  call SearchHighlight()
  endfun

  " Highlight entry
  nnoremap <silent> n :call SearchNext()<CR>
  nnoremap <silent> N :call SearchPrev()<CR>
endif

if 0
" Damian Conway's Die Blinkënmatchen: highlight matches
nnoremap <silent> n n:call HLNext(0.2)<cr>
nnoremap <silent> N N:call HLNext(0.2)<cr>

function! HLNext (blinktime)
  let target_pat = '\c\%#'.@/
  let ring = matchadd('ErrorMsg', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction
endif

" Command Abbreviation {{{2
" simple version of cmdalias.vim
function! CommandCabbr(abbreviation, expansion)
  execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction
command! -nargs=+ CommandCabbr call CommandCabbr(<f-args>)
" Use it on itself to define a simpler abbreviation for itself.
CommandCabbr ccab CommandCabbr

" Capture messages in new window {{{2
:com! -nargs=1 Exe :redir => a|exe "sil " <q-args>|redir end|new |set buftype=nofile|0put =a
:com! Messages Exe mess
" Quickfix Do command {{{2
" :QFDo! iterates over location list
" :QFDo iterates over quickfix list
" Define Function Quick-Fix-List-Do:
fun! QFDo(bang, command) 
     let qflist={} 
     if a:bang 
         let tlist=map(getloclist(0), 'get(v:val, ''bufnr'')') 
     else 
         let tlist=map(getqflist(), 'get(v:val, ''bufnr'')') 
     endif 
     if empty(tlist) 
        echomsg "Empty Quickfixlist. Aborting" 
        return 
     endif 
     for nr in tlist 
     let item=fnameescape(bufname(nr)) 
     if !get(qflist, item,0) 
         let qflist[item]=1 
     endif 
     endfor 
     :exe 'argl ' .join(keys(qflist)) 
     :exe 'argdo ' . a:command 
endfunc 

com! -nargs=1 -bang Qfdo :call QFDo(<bang>0,<q-args>) 

" when typing : and = let it have aligned automatically.
"inoremap <silent> :   :<Esc>:call <SID>align(':')<CR>a
"inoremap <silent> =   =<Esc>:call <SID>align('=')<CR>a

function! s:align(aa)
  if !exists(":Tabularize")
	return
  endif
  let p = '^.*\s'.a:aa.'\s.*$'
  if (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^'.a:aa.']','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*'.a:aa.':\s*\zs.*'))
    exec 'Tabularize/'.a:aa.'/l1'
    normal! 0
    call search(repeat('[^'.a:aa.']*'.a:aa,column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
" Restore: "{{{2
let &cpo=s:cpo
unlet s:cpo
" vim: ts=4 sts=4 fdm=marker com+=l\:\"
