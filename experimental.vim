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

"au TabLeave * :let g:last_tab=tabpagenr()

"fu! <sid>LastTab()
"    if !exists("g:last_tab")
"	return
"    endif
"    exe "tabn" g:last_tab
"endfu

"nnoremap <silent> <F8> :call <sid>LastTab()<cr>
"nmap <silent> <F7> :exe "tabn" exists("g:last_tab") ? g:last_tab :''<cr>

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
"
"
"    fu! MySignsToggle()
"        if !has("signs") || empty(bufname(''))
"            return
"        endif
"        if !exists("s:signfile")
"            let s:signfile = tempname().'_'
"        endif
"        redir =>a|exe "sil sign place buffer=".bufnr('')|redir end
"        let signs = split(a, "\n")[1:]
"        if !empty(signs)
"            let bufnr = bufnr('')
"            exe ":sil SaveSigns!" s:signfile.bufnr('')
"            if bufnr('') != bufnr
"                exe "noa wq"
"            endif
"            sign unplace *
"        elseif filereadable(s:signfile.bufnr(''))
"            exe "so" s:signfile.bufnr('')
"            call delete(s:signfile.bufnr(''))
"        endif
"    endfu
    

"au VimEnter * exe (localtime()%winnr('$')+1). "wincmd R|1wincmd w"
