"-------------------------------------------------------
" Global .vimrc Settings from 
" Christian Brabandt <cb@256bit.org>
"
" Last update: Thu 2010-09-23 19:43
"-------------------------------------------------------
" Personal Vim Configuration File
"  

" do NOT behave like original vi
" I like vim's  features a lot better
" This is already set automatically by sourcing a .vimrc
" set nocp

" set Unicode if possible
" First, check that the necessary capabilities are compiled-in
if has("multi_byte")
        " (optional) remember the locale set by the OS
        let g:locale_encoding = &encoding
        " if already Unicode, no need to change it
        " we assume that an encoding name is a Unicode one
        " iff its name starts with u or U
        if &encoding !~? '^u'
                " avoid clobbering the keyboard's charset
                if &termencoding == ""
                        let &termencoding = &encoding
                endif
                " now we're ready to set UTF-8
                set encoding=utf-8
        endif
        " heuristics for use at file-open
	" how are different fileencodings determined?
	" This is a list. The first that succeeds, will be used
	" default is 'ucs-bom,utf-8,default,latin1'
        set fileencodings=ucs-bom,utf-8,latin9
        " optional: defaults for new files
        "setglobal bomb fileencoding=utf-8
endif
" ~/local/share/vim/vim73 should contains the newest runtime files
" Always have ~/.vim at first position.
set rtp-=~/.vim
set rtp^=/home/chrisbra/local/share/vim/vim73/
set rtp^=~/.vim
" allow switching of buffers without having to save them
set hidden

" when joining, prevent inserting an extra space before a .?!
set nojoinspaces

" vi compatible, set $ to line end, when chaning text
set cpo+=$

" Turn on filetype detection plugin and indent for specific 
filetype plugin indent on

" Always turn syntax highlighting on
syntax on

" Tweak timeouts, because the default is too conservative
" This setting is taken from :h 'ttimeoutlen'
set timeout timeoutlen=3000 ttimeoutlen=100

" Turn on: auto-indent, ruler, show current mode,
"          showmatching brackets, show additional info, 
"          show always status line
set ai ruler showmode showmatch wildmenu showcmd ls=2

" Search options: ignore case, increment search, no highlight, smart case
" nostartofline option
set ic incsearch hlsearch smartcase nostartofline

" show partial lines
set display+=lastline


"whichwrap those keys move the cursor to the next line if at the end of the
"line
set ww=<,>,h,l

" when using :scrollbind, also bind scrolling horizontally
set scrollopt+=hor

" Use of a .viminfo file
"set viminfo=%,!,'50,\"100,:100
set viminfo=!,'50,\"100,:100

" Commandline Completion
set wildmode=list:longest,longest:full

" Enable file modelines
set modelines=1

" Format options: see :h fo-table
" set fo=tcqrn

" Tabstop options
" one tab indents by 8 spaces (this is the default for most display utilities) 
" and so it will look like the same
set ts=8
" softtabstops make you feel, a tab is 4 spaces wide, instead the default
" 8. This means display utilities will still see 8 character wide tabs,
" while in vim, a tab looks like 4 characters
set softtabstop=4
" the amount to indent when using ">>" or autoindent.
set shiftwidth=4
" round indent to multiple of 'sw'
set shiftround  

" Set backspace (BS) mode: eol,indent,start
set bs=2

" Display a `+' for wrapped lines
set sbr=+

" Set shell
set sh=bash

" Numberformat to use, unsetting bascially only allows decimal
" octal and hex may make trouble if tried to increment/decrement
" certain numberformats
" (e.g. 007 will be incremented to 010, because vim thinks its octal)
set nrformats=

"---------------------------------------------
" Keyword completion
"---------------------------------------------

" set dictionary. Press <CTRL>X <CTRL> K for looking up
" use german words, see debian package `wngerman'
" set dictionary=/usr/share/dict/ngerman
set dictionary=/usr/share/dict/words

"au FileType mail   so ~/.vim/mail.vim
au FileType tex    so ~/.vim/latex.vim
au BufRead changes nmap ,cb o<CR>chrisbra, <ESC>:r!LC_ALL='' date<CR>kJo-
au BufNewFile,BufRead *.csv setf csv

"-------------------------------------------------------
" STATUSBAR
" ------------------------------------------------------
set laststatus=2
if has("statusline")
    set statusline=
    set statusline+=%-3.3n\                      " buffer number
    set statusline+=%f\                          " file name
    set statusline+=%h%m%r%w                     " flags
    set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
"    set statusline+=%{&encoding},                " encoding
    set statusline+=%{(&fenc==\"\"?&enc:&fenc)},
    set statusline+=%{&fileformat}              " file format
    set statusline+=%{(&bomb?\",BOM\":\"\")}]	 " BOM
    set statusline+=%=                           " right align
    "set statusline+=0x%-8B\                      " current char
    set statusline+=%-10.(%l,%c%V%)\ %p%%        " offset
    "set statusline=%<%f\ %h%m%r%=%k[%{(&fenc\ ==\ \"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %-12.(%l,%c%V%)\ %P
endif

"---------------------------------------------
" Using Putty for scp on Windows on Windows
"---------------------------------------------
if ($OS =~"Windows")
    let g:netrw_scp_cmd="\"c:\\Program Files\\PuTTY\\pscp.exe\" -q -batch"
endif


" GnupgSymmetric:
" see: http://www.vim.org/scripts/script.php?script_id=1403
"
" De- and Encrypting Files synchroneously using GPG
"source ~/.vim/gnupg-symmetric.vim

" PotWiki:
" http://www.vim.org/scripts/script.php?script_id=1018
"
" A Vim Script to create a wiki using plaintext files
" see :h potwiki
"let potwiki_dir = "$HOME/Wiki/"


" Matching of IP-Addresses Highlight in yellow
highlight ipaddr term=bold ctermfg=yellow guifg=yellow
" highlight ipaddr ctermbg=green guibg=green
match ipaddr /\(\(25\_[0-5]\|2\_[0-4]\_[0-9]\|\_[01]\?\_[0-9]\_[0-9]\?\)\.\)\{3\}\(25\_[0-5]\|2\_[0-4]\_[0-9]\|\_[01]\?\_[0-9]\_[0-9]\?\)/ 


"---------------------------------------------
" This will highlight the line on which 
" a search pattern matches.
"---------------------------------------------
"au CursorHold * if getline('.') =~ @/ | exe 'match LineNr /\%' .  line(".") . 'l.*/' | else | match | endif
"set updatetime=20

"---------------------------------------------
" Vim 7 Features
"---------------------------------------------
if version >= 700
    " Minibuffexplorer: is not needed, as vim 7 provides tabbing
    " therefore diabling it:
    let loaded_minibufexplorer=1

    " Disbale vimspell (was needed for spellchecking in versions < 7)
    let loaded_vimspell=1
    
    " Enable autoinstalling the newest Plugins using GetLatextVimScripts
    let g:GetLatestVimScripts_allowautoinstall=1
    " Change the disturbing pink color for omnicompletion
    hi Pmenu guibg=DarkRed
    set spellfile=~/.vim/spellfile.add

    " change language -  get spell files from http://ftp.vim.org/pub/vim/runtime/spell/
    " cd ~/.vim/spell && wget http://ftp.vim.org/pub/vim/runtime/spell/de.latin1.spl
    " change to german:
    set spelllang=de,en
    " set maximum number of suggestions listed to top 10 items
    set sps=best,10

    " highlight matching parens:
    " Default for matchpairs: (:),[:],{:},<:>
     set matchpairs+=<:>
     highlight MatchParen term=reverse   ctermbg=7   guibg=cornsilk

    " What to display in the Tabline
    set tabline=%!MyTabLine()

    " Define :E for opening a new file in a new tab
    command! -nargs=* -complete=file E :tabnew <args> 
else
    " Minibufferexplorer:
    " see: http://www.vim.org/scripts/script.php?script_id=159
    "
    " Used to display the several different files in a small top windows
    " like tabbing in firefox
    " First enable mapping Control+Vim Direction keys [hkjl]
    let g:miniBufExplMapWindowNavVim = 1
    " Now enable mapping of Control + Arrow Keys to window 
    let g:miniBufExplMapWindowNavArrows = 1
    " Finally enable Mapping of Ctrl+TAB/Ctrl+Shift-TAB for cycling between
    " the files
    let g:miniBufExplMapCTabSwitchBufs = 1
    " There is a bug in vim, to not always show up with syntax highlighting
    " together with the minibufexpl Script. This can be circumvented by:
    let g:miniBufExplForceSyntaxEnable = 1
    " Mappings for Minibufexpl
    " switch to next buffer
    " nmap <C-j> :MBEbn<CR>
    nmap Oc  :MBEbn<CR>
    " switch to previous buffer
    " nmap <C-k> :MBEbp<CR>
    nmap Od  :MBEbp<CR>
    "
    " The following Plugins need a vim version > 700
    " NERD Commenter 
    let loaded_nerd_comments = 1
    " genutils 
    let loaded_genutils = 1
    " lookupfile
    let g:loaded_lookupfile = 1
    " undo_tags
    let loaded_undo_tag=1
    " yankring
    let loaded_yankring = 30
    " vcscommand
    let loaded_VCSCommand = 1
endif


if version >= 600
" Folding:
" This works only with vim > 6
    set foldenable
    set foldmethod=marker
    set foldlevel=1
    "set foldcolumn=1
endif

if (&term =~ '^screen')
  " set title for screen
  " VimTip #1126
  " set t_ts=k t_fs=\\ title
  set title t_Co=256
  set t_ts=k
  set t_fs=\
  let &titleold = fnamemodify(&shell, ":t")
  set titlelen=15
  " set information for title in screen (see :h 'statusline')
  set titlestring=%t%=%<%(\ %{&encoding},[%{&modified?'+':'-'}],%p%%%)
  com! -complete=help -nargs=+ H :!screen -t 'Vim-help' vim -c 'help <args>' -c 'only'
elseif (&term =~ 'putty\|xterm-256\|xterm-color')
    " Let's have 256 Colors. That rocks!
    " Putty and screen are aware of 256 Colors on recent systems
    set t_Co=256 title
    "let &titleold = fnamemodify(&shell, ":t")
    "set t_AB=^[[48;5;%dm
    "set t_AF=^[[38;5;%dm
endif

" console vim has usually a dark background,
" while in gvim I usually use a light background
"if has("gui_running")
"    set bg=light
"else
"    set bg=dark 
"endif

" Set a color scheme. I especially like 
" desert and darkblue
if (&t_Co == 256)
    colorscheme cb256
    "colorscheme desert
    " Highlight of Search items is broken in desert256 
    " so fix that
    "hi Search ctermfg=0 ctermbg=159
else
    colorscheme desert
endif
" Highlight of Search items is broken in desert256 
" so fix that


" In Diff-Mode turn off Syntax highlighting
if &diff | syntax off | endif

" Special characters that will be shown, when set list is on
set listchars=tab:>-,trail:~,eol:$

" Set the tags file
"set tags=~/tags

if has('cscope')
  set cscopetag cscopeverbose

  if has('quickfix')
    set cscopequickfix=s-,c-,d-,i-,t-,e-
  endif

"  cnoreabbrev csa cs add
"  cnoreabbrev csf cs find
"  cnoreabbrev csk cs kill
"  cnoreabbrev csr cs reset
"  cnoreabbrev css cs show
"  cnoreabbrev csh cs help
    cnoreabbrev <expr> csa
          \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs add'  : 'csa')
    cnoreabbrev <expr> csf
          \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs find' : 'csf')
    cnoreabbrev <expr> csk
          \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs kill' : 'csk')
    cnoreabbrev <expr> csr
          \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs reset' : 'csr')
    cnoreabbrev <expr> css
          \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs show' : 'css')
    cnoreabbrev <expr> csh
          \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs help' : 'csh')

  
    let $VIMSRC='/home/chrisbra/code/vim'
    command -nargs=0 Cscope cs add $VIMSRC/src/cscope.out $VIMSRC/src
endif

if has('persistent_undo')
    set undofile
endif


" Add ellipsis … to the digraphs
" this overwrite the default, but my current font won't display that 
" letter anyway ;)
digraphs .3 8230

if &encoding == "utf-8"
"    set listchars=eol:$,trail:·,tab:>>·,extends:>,precedes:<
    set listchars=eol:$,trail:-,tab:>-,extends:>,precedes:<
else
    set listchars=eol:$,trail:-,tab:>-,extends:>,precedes:<
endif


" source local .vimrc
" This is potentialy dangerous
"fu! LocalVimrc()
"   if  filereadable(expand("%:p:h")."/.vimrc")
"       source %:p:h/.vimrc
"   endif
"endfu

"---------------------------------------------
" Insert external vim sources
"---------------------------------------------
source ~/.vim/mapping.vim
" The next script is not needed anymore, since I am now using
" vimspell: http://www.vim.org/scripts/script.php?script_id=465
"source ~/.vim/spelling.vim
source ~/.vim/functions.vim
" Boxquotes
source ~/.vim/boxquotes.vim
" For abbreviations read in the following file:
source ~/.vim/abbrev.vim

" 2html setting:
let html_whole_filler=1

" some debug mappings
noremap g+ g+\|:echo 'Change: '.changenr().' Save: '.changenr(1)<cr>
noremap g- g-\|:echo 'Change: '.changenr().' Save: '.changenr(1)<cr>
noremap g\ :echo 'Change: '.changenr().' Save: '.changenr(1)<cr>

":command! Print echo 'test print'
":command! X echo 'test X'
":command! Next echo 'test Next'
":command! Pint1 echo 'print'
