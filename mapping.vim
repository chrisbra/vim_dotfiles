"-------------------------------------------------------
" Vim Setting for Mappings
" Christian Brabandt <cb@256bit.org>
"
" Last update: Fr 2010-10-08 13:39

"-------------------------------------------------------
" Useful mappings
"---------------------------------------------------------
" Fold all regions except the visually selected one:
vnoremap ,h :<c-u>1,'<lt>-fold<bar>'>+,$fold<CR>

" make <BS> <DEL> <C-U> and <C-W> undoable
" h i_Ctrl-g_u
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
inoremap <BS> <C-G>u<BS>
inoremap <DEL> <C-G>u<DEL>

nmap <F7> :call ToggleFoldByCurrentSearchPattern()<CR>

" mapping of CTRL-] to ALT-ß-ß for jumping in vim help files
map \\ <C-]> 

" don't mess up vim, when inserting with the mouse
set pastetoggle=<F10> 

" Insert last buffer with ^E in insert mode
imap  pa
" You are too fast and keep pressing `shift' if you type :w, try following
":command! -bang W w<bang>
command! -bang -bar -nargs=? -complete=file -range=% W  <line1>,<line2>w<bang> <args>
command! -bang Wq wq<bang>
command! -bang Q q<bang>
" disallow opening the commandline window which by default is bound to 
" q: (I tend to usually mean :q)
" The commandline window is still accessible using q/ or q?
" noremap q: :q
" Pressing `Enter' inserts a new line
" only if buffer is modifiable (e.g. not in help or quickfix window)
" if (&ma)
"    nmap <buffer> <CR> i<CR><ESC>
" endif

" In help files, map Enter to follow tags
au BufWinEnter *.txt if(&ft =~ 'help')| nmap <buffer> <CR> <C-]> |endif

" execute the command in the current line (minus the first word, which
" is intended to be a shell prompt and needs to be $) and insert the 
" output in the buffer
nmap ,e ^wy$:r!<cword><CR>

" for editing a file with other users, this will insert my name and 
" the date, when I edited
" map ,cb ochrisbra, :r!LC_ALL='' date<CR>kJo-
" nmap ,cb ochrisbra, <ESC>:r!LC_ALL='' date<CR>kJo-
"nmap ,cb o<CR>chrisbra, <ESC>:r!LC_ALL='' date<CR>kJo-

" Plugin: NERD_commenter.vim
" (see: http://www.vim.org/scripts/script.php?script_id=1218)
" Allows to comment lines in different languages
" Comment current line
nmap ,co ,cc
" uncoment current line
nmap ,uco ,cu
" toggle comment current line
nmap ,tco ,c<space>
" Do not yiel about unknown filetypes.
let NERDShutUp=1

" map the DiffOrig command to  <leader>do
" HINT: *d*iff with *o*riginal file
"map <leader>do :silent! ShowDifferences<CR>
map <leader>do :silent! call ToggleDiffOrig()<CR>

" Scroll using the visible lines
map j gj
map k gk
if exists("*pumvisible")
    inoremap <expr> <Down> pumvisible() ? "\<lt>Down>" : "\<lt>C-O>gj"
    inoremap <expr> <Up>   pumvisible() ? "\<lt>Up>"   : "\<lt>C-O>gk"
else
   inoremap <Down> <C-O>gj
   inoremap <Up>   <C-O>gk
endif

" Compile the currently editing Script
" This can also be done by using
" set makeprg (see help 'makeprg')
nnoremap <F4> :call CompileScript()<CR>

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
map ,V :%!par w50<CR>

" Attach Files with muttng using \A
" map __a_start :imap <C-V><CR> <C-O>__a_cmd\|imap <C-V><ESC> <C-V><ESC>__a_end\|imap <C-V><C-V><C-V><C-I> <C-V><C-N>\|imap <C-V><C-N> <C-V><C-X><C-V><C-F><CR>
" noremap __a_end :iunmap <C-V><CR>\|iunmap <C-V><ESC>\|iunmap <C-V><C-V><C-V><C-I>\|iunmap <C-V><C-V><C-V><C-N><CR>dd`a:"ended.<CR>
" noremap __a_cmd oAttach:<Space>
" noremap __a_scmd 1G/^$/<CR>:noh<CR>OAttach:<Space>
" map <leader>a ma__a_start__a_scmd


" Notations
"<C-M> == <CR>
