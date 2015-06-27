"-------------------------------------------------------
" Vim Setting for Mappings
" Christian Brabandt <cb@256bit.org>
"
" Last update: Fr 2014-03-07 13:08

"-------------------------------------------------------
" Useful mappings
"---------------------------------------------------------
" Fold all regions except the visually selected one:
vnoremap ,h :<c-u>1,'<lt>-fold<bar>'>+,$fold<CR>

nnoremap <F7> :call ToggleFoldByCurrentSearchPattern()<CR>

" n always searches downwards, N always upwards
noremap <expr> n 'Nn'[v:searchforward]
noremap <expr> N 'nN'[v:searchforward]

" don't mess up vim, when inserting with the mouse
set pastetoggle=<F10> 

" In help files, map Enter to follow tags
augroup CustomHelp
    au!
    au BufWinEnter *.txt if(&ft =~ 'help')| nmap <buffer> <CR> <C-]> |endif
augroup END

" execute the command in the current line (minus the first word, which
" is intended to be a shell prompt and needs to be $) and insert the 
" output in the buffer
"nmap ,e ^wy$:r!<cword><CR>

" map the DiffOrig command to  <leader>do
" HINT: *d*iff with *o*riginal file
map <leader>do :silent! call ToggleDiffOrig()<CR>

if exists("*pumvisible")
    inoremap <expr> <Down> pumvisible() ? "\<lt>Down>" : "\<lt>C-O>gj"
    inoremap <expr> <Up>   pumvisible() ? "\<lt>Up>"   : "\<lt>C-O>gk"
else
   inoremap <Down> <C-\><C-O>gj
   inoremap <Up>   <C-\><C-O>gk
endif

" Compile the currently editing Script
" This can also be done by using
" set makeprg (see help 'makeprg')
" nnoremap <F4> :call CompileScript()<CR>

if has("gui")
    nmap <F2> :sil! :browse confirm save<CR>
    nmap <F3> :sil! :browse confirm open<CR>
endif 

" Highlight Text inside matching paranthesis
" see http://www.vim.org/tips/tip.php?tip_id=1017
" use Ctrl-p
" --- not used
"nmap <C-p> m[%v%:sleep 500m<CR>`[

if version > 700
    " turn spelling on by default:
    " set spell
    " toggle spelling with F12 key:
    map <F12> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>
endif

"---------------------------------------------------------
" Experimental Settings
"---------------------------------------------------------
"
" Using par to reformat a file
" map ,V :%!par w50<CR>

" make n/N for search work more intuitevely
" http://groups.google.com/group/vim_use/msg/6ff8586688e52b7d
" ono m //e<CR>
" xn <script> m //e<SID>SelOff<CR>
" cno <expr> <SID>SelOff &sel=="exclusive" ? "+1" : ""
" " do the right thing after o_//e and .
" no <script> n //<CR><SID>HistDel
" no <script> N ??<CR><SID>HistDel
" sunm n|sunm N
" nn <silent> <SID>HistDel :call<sid>HistDel(0)<CR>
" vn <silent> <SID>HistDel :<C-U>call<sid>HistDel(1)<CR>
" ino <silent> <SID>HistDel <C-R>=<sid>HistDel(0)<CR>
" func! <sid>HistDel(vmode)
"     if a:vmode
"         normal! gv
"     endif
"     call histdel('/', -1)
"     return ""
" endfunc

" Vim Tips wiki Tip 171 https://vim.wikia.com/wiki/VimTip171
fu! s:VSetSearch(cmdtype)
    let _t = @s
    norm! gv"sy
    let @/ = '\V'. substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = _t
endfu

xnoremap * :<C-U>call <sid>VSetSearch('/')<CR>/<C-R>/<C-R>=@/<CR><CR>
xnoremap # :<C-U>call <sid>VSetSearch('?')<CR>/<C-R>?<C-R>=@/<CR><CR>

nnoremap <expr> j (v:count ? 'j' : 'gj')
nnoremap <expr> k (v:count ? 'k' : 'gk')

" ["x][N]""         List contents of the passed register / [N] named
"                   registers / all registers (that typically contain
"                   pasteable text).
nnoremap <silent> <expr> "" ':<C-u>registers ' . (v:register ==# '"' ? (v:count ? strpart('abcdefghijklmnopqrstuvwxyz', 0, v:count1) : '"0123456789abcdefghijklmnopqrstuvwxyz*+.') : v:register) . "<CR>"
