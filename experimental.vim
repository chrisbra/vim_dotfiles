
"set splitvertical
set diffopt+=horizontal
" 
" some debug mappings
"noremap g+ g+\|:echo 'Change: '.changenr().' Save: '.changenr(1)<cr>
"noremap g- g-\|:echo 'Change: '.changenr().' Save: '.changenr(1)<cr>
"noremap g\ :echo 'Change: '.changenr().' Save: '.changenr(1)<cr>


hi User1 term=standout ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow
function! MySTL()
    if has("statusline")
	let stl='%-3.3n %f %{exists("b:mod")?("[".b:mod."]") : ""} %h%m%r%w[%{strlen(&ft)?&ft:"none"},%{(&fenc==""?&enc:&fenc)},%{&fileformat}%{(&bomb?",BOM":"")}]%=%-10.(%l,%c%V%) %p%%'
	if exists("*CSV_WCol")
	    let csv = '%1*%{&ft=~"csv" ? CSV_WCol("Name") . " " . CSV_WCol() : ""}%*'
	else
	    let csv = ''
	endif
	return stl.csv
    endif
endfunc
set stl=%!MySTL()
let g:csv_hiHeader="DiffAdd"

lan mess C
lan ctype C

":command! Print echo 'test print'
":command! X echo 'test X'
":command! Next echo 'test Next'
":command! Pint1 echo 'print'

"set verbose=1
set undodir=~/.vim/undo/

"set bdir=/tmp/vim_backupdir
"set backup
"set bkc=yes
"set backupskip=
"set rnu
"set nonu
"set list

au TabLeave * :let g:last_tab=tabpagenr()

fu! <sid>LastTab()
    if !exists("g:last_tab")
	return
    endif
    exe "tabn" g:last_tab
endfu

nnoremap <silent> <F8> :call <sid>LastTab()<cr>
nmap <silent> <F7> :exe "tabn" exists("g:last_tab") ? g:last_tab :''<cr>

"let g:csv_autocmd_arrange = 1
let g:Signs_QFList = 0
"let g:Signs_Diff = 1
"let g:Signs_Bookmarks = 1
"let g:Signs_Alternate = 1
"let g:checkattach_filebrowser = 'range'
"aug CSV_Editing
"    au!
"    au BufRead,BufWritePost *.csv :%ArrangeColumn
"    au BufWritePre *.csv :%UnArrangeColumn
"aug end

"if &term =~ "xterm\\|rxvt"
"    " use an orange cursor in insert mode
"    let &t_SI = "\<Esc>]12;orange\x7"
"    " use a red cursor otherwise
"    let &t_EI = "\<Esc>]12;red\x7"
"    silent !echo -ne "\033]12;red\007"
"    " reset cursor when vim exits
"    autocmd VimLeave * silent !echo -ne "\033]112\007"
"    " use \003]12;gray\007 for gnome-terminal
"endif
"let g:auto_color = 1
":au BufNewFile,BufRead *.css,*.html,*.htm  :ColorHighlight!
let g:csv_comment = '#'
dig -- 8212
dig \|- 166
" Debug SudoEdit plugin
"let g:sudoDebug=1
" Colorizer Plugin
let g:colorizer_auto_filetype="vim,html"
"let g:colorizer_skip_comments = 1
let g:colorizer_colornames = 1
set wak=no
let b:nrrw_aucmd_close= "unlet! g:nrrw_custom_options"
"let g:Signs_Scrollbar = 1
let g:Signs_Bookmarks = 1
let g:SignsMixedIndentation = 1
"let g:Signs_Diff = 1
"
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
"au BufWinEnter * if empty(&ft) 
"	    \| setl indentexpr=indent(prevnonblank(v:lnum-1))
"	    \| setl indentkeys-=o
"	    \| let b:undo_ftplugin='setl inde< indk<'
"	    \| endif

"fu! Unload()
"    echom b:undo_ftplugin
"    echom expand("<afile>")
"    exe b:undo_ftplugin
"    let b:foobar=1
"endfu

"au BufUnload * :call Unload()
