
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
	    let csv = '%1*%{&ft=~"csv" ? CSV_WCol() : ""}%*'
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
"set undodir=~/.vim/undo/

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
