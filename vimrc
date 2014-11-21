"-------------------------------------------------------
" Global .vimrc Settings from
" Christian Brabandt <cb@256bit.org>
" Last update: Fr 2014-05-02 13:50
"-------------------------------------------------------
" Personal Vim Configuration File
"
" do NOT behave like original vi
" I like vim's features a lot better
" This is already set automatically by sourcing a .vimrc
" set nocp

" set Unicode if possible
" First, check that the necessary capabilities are compiled-in
" needs to be set first
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

if has("gui")
    " Do not load menus for gvim. Must come before filetype and syntax command!
    set go=M
endif

if !empty(glob('$HOME/.vim/autoload/pathogen.vim'))
    " Use pathogen as plugin manager
    call pathogen#infect()
    call pathogen#helptags()
endif
" Always have ~/.vim at first position.
set rtp^=~/.vim
" allow switching of buffers without having to save them
set hidden

" Enable file modelines (default is ok)
set modeline modelines=1

" when joining, prevent inserting an extra space before a .?!
set nojoinspaces
" vi compatible, set $ to line end, when chaning text
set cpo+=$
" prefer a dark background (important to get the colorscheme right)
set bg=dark
" Turn on filetype detection plugin and indent for specific
if exists(":filetype") == 2
    filetype plugin indent on
endif
" Tweak timeouts, because the default is too conservative
" This setting is taken from :h 'ttimeoutlen'
set timeout timeoutlen=3000 ttimeoutlen=100

" Turn on: auto-indent, ruler, show current mode,
"          showmatching brackets, show additional info,
"          show always status line
set ai ruler showmode showmatch wildmenu showcmd ls=2

" Search options: ignore case, increment search, no highlight, smart case
" nostartofline option
set incsearch nohlsearch smartcase nostartofline ignorecase
" show partial lines
set display+=lastline
"whichwrap those keys move the cursor to the next line if at the end of the
"line
set ww=<,>
" when using :scrollbind, also bind scrolling horizontally
set scrollopt+=hor
" English messages please
lang mess C
lang ctype C
" how many entries in the commandline history to save
set history=1000
" Commandline Completion
set wildmode=list:longest,longest:full
" Always turn syntax highlighting on
" should come after filetype plugin command
if has("syntax")
    syntax on
    
    " highlight VCS conflict markers
    " highlight strange Whitespace
    aug CustomHighlighting
	au!
	au WinEnter * if !exists("w:custom_hi1") | match ErrorMsg /^\(<\|=\|>\)\{7\}\([^=].\+\)\?$/ |let w:custom_hi1 = 1|endif
	au WinEnter * if !exists("w:custom_hi2") | match ErrorMsg /[\x0b\x0c\u00a0\u1680\u180e\u2000-\u200a\u2028\u202f\u205f\u3000\ufeff]/ | let w:custom_hi2 = 1| endif
    aug END

    " Make VertSplit take the same background as Normal
    hi! link VertSplit Normal
    if has("conceal")
	hi! link Conceal Normal
    endif
endif

" Tabstop options
" one tab indents by 8 spaces (this is the default for most display utilities)
" and so it will look like the same
"set ts=8
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
set sh=zsh

" Numberformat to use, unsetting bascially only allows decimal
" octal and hex may make trouble if tried to increment/decrement
" certain numberformats
" (e.g. 007 will be incremented to 010, because vim thinks its octal)
set nrformats=

" Breakindent
if exists('+breakindent')
    set bri
    set briopt=min:20
endif

if exists('+langnoremap')
    " prevent langmap option from remapping the right side of a mapping
    set langnoremap
endif

" set dictionary. Press <CTRL>X <CTRL> K for looking up
" use german words, see debian package `wngerman'
set dictionary=/usr/share/dict/words

if has("autocmd")
    aug custom_BufRead
	au!
	au BufRead changes nmap ,cb o<CR>chrisbra, <ESC>:r!LC_ALL='' date<CR>kJo-
    augroup END
endif

if ($OS =~"Windows")
    let g:netrw_scp_cmd="\"c:\\Program Files\\PuTTY\\pscp.exe\" -q -batch"
endif

"---------------------------------------------
" Vim 7 Features
"---------------------------------------------
if version >= 700
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
     highlight MatchParen term=reverse ctermbg=7 guibg=cornsilk
endif

if has("folding")
    set foldenable foldmethod=marker foldlevelstart=0
endif

let &titleold = fnamemodify(&shell, ":t")
let _bg = &bg " save current bg, might get reset below

if exists("$PUTTY_TERM")
    " putty works mostly like xterm (in fact more features work OOTB
    " pretending to be an xterm compatible terminal (cursor keys, etc),
    " so use that one instead of putty-256color
    set term=xterm-256color t_Co=256 title
elseif (&term =~ '^screen')
  "if expand("$COLORTERM") !~ 'rxvt'
    set t_Co=256
    set title
    set t_ts=k
    set t_fs=\
    set titlelen=15
    " set information for title in screen (see :h 'statusline')
    set titlestring=%t%=%<%(\ %{&encoding},[%{&modified?'+':'-'}],%p%%%)
    com! -complete=help -nargs=+ H :!screen -t 'Vim-help' vim -c 'help <args>' -c 'only'
    " Make Vim recognize xterm escape sequences for Page and Arrow
    " keys combined with modifiers such as Shift, Control, and Alt.
    " See http://www.reddit.com/r/vim/comments/1a29vk/_/c8tze8p
    " needs in tmux.conf: setw -g xterm-keys on
    " Page keys http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
    execute "set t_kP=\e[5;*~"
    execute "set t_kN=\e[6;*~"

    " Arrow keys http://unix.stackexchange.com/a/34723
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
elseif (&term =~ 'xterm-256\|xterm-color\|xterm')
    " Let's have 256 Colors. That rocks!
    " Putty and screen are aware of 256 Colors on recent systems
    set t_Co=256 title
    "let &titleold = fnamemodify(&shell, ":t")
    "set t_AB=^[[48;5;%dm
    "set t_AF=^[[38;5;%dm
endif

if !empty(&t_ut)
    " see http://snk.tuxfamily.org/log/vim-256color-bce.html
    " Not neccessary? (see below
    let &t_ut=''
endif

if (&t_Co == 256) || (&t_Co == 88) || has("gui_running")
    "let g:solarized_termcolors=256
    colors molokai
else
    colorscheme desert
endif

" restore bg value, might be reset by the colorscheme
let &bg=_bg
unlet _bg

" In Diff-Mode turn off Syntax highlighting
if &diff | syntax off | endif

if has('cscope')
  set cscopetag cscopeverbose
  if has('quickfix')
    set cscopequickfix=s-,c-,d-,i-,t-,e-
  endif
endif

if has('persistent_undo')
    set undofile
    set undodir=~/.vim/undo/
endif

" Add ellipsis … to the digraphs
" this overwrite the default, but my current font won't display that
" letter anyway ;)
digraphs .3 8230
digraphs -- 8212
digraphs \|- 166

if &encoding == "utf-8"
    if !exists("$PUTTY_TERM")
	exe "set listchars=nbsp:\u2423,conceal:\u22ef,tab:\u2595\u2014,trail:\u02d1,precedes:\u2026,extends:\u2026,eol:\ub6"
    else
	" Putty can't display all nice utf-8 chars
	exe "set listchars=conceal:·,tab:>\u2014,trail:\u02d1,precedes:\u2026,extends:\u2026,eol:\ub6"
    endif
    exe "set fillchars=vert:\u2502,fold:\u2500,diff:\u2014"
else
    " Special characters that will be shown, when set list is on
    set listchars=eol:$,trail:-,tab:>-,extends:>,precedes:<,conceal:+
endif

" This script contains plugin specific settings
source ~/.vim/plugins.vim
" This script contains mappings
source ~/.vim/mapping.vim
source ~/.vim/functions.vim

" source matchit
ru macros/matchit.vim

" experimental and debug settings
" (possibly not even available in vanilla vim)
" source ~/.vim/experimental.vim

" In case /tmp get's clean out, make a new tmp directory for vim:
if has("user_commands")
  command! Mktmpdir call mkdir(fnamemodify(tempname(),":p:h"),"",0700)
endif

" if ctag or cscope open a file that is already opened elsewhere, make sure to
" open it in Read-Only Mode
" http://groups.google.com/group/vim_use/msg/5a1726ea0fd654d1
if exists("##SwapExists")
    augroup Custom_Swap
	au!
	autocmd SwapExists * if v:swapcommand =~ '^:ta\%[g] \|^\d\+G$' | let v:swapchoice='o' | endif
    augroup END
endif

" open file at last position
" :h last-position-jump
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"zvzz" | endif
