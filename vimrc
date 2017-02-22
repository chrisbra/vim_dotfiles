"-------------------------------------------------------
" Global .vimrc Settings from
" Christian Brabandt <cb@256bit.org>
"-------------------------------------------------------

" This is already set automatically by sourcing a .vimrc
" set nocp

" set Unicode if possible
" First, check that the necessary capabilities are compiled-in
" needs to be set first
if has("multi_byte")
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

" don't want any menus, just an term like gvim
" needs to come first, because :syn on and :filetype
" would else load the system menu
if has("gui")
  " Do not load menus for gvim. Must come before filetype and syntax command!
  set go=cM
endif

if filereadable('$HOME/.vim/autoload/pathogen.vim') && v:version < 800
  " Use pathogen as plugin manager
  call pathogen#infect()
  call pathogen#helptags()
elseif v:version >= 800
    " all plugins below ~/.vim/pack/dist/start/* are loaded automatically
endif

" Turn on filetype detection plugin and indent for specific
if exists(":filetype") == 2
  filetype plugin indent on
endif

" Always turn syntax highlighting on
" should come after filetype plugin command
if has("syntax")
  syntax on
endif

" Always have ~/.vim at first position.
set rtp^=~/.vim
" allow switching of buffers without having to save them
set hidden

" Enable file modelines (default is ok)
set modeline modelines=5

if exists('+fixeol')
  set nofixeol
endif

if exists('+belloff')
  set belloff=all
endif

" don't scan included files
set complete-=i

" when joining, prevent inserting an extra space before a .?!
set nojoinspaces
" vi compatible, set $ to line end, when chaning text
set cpo+=$
" prefer a dark background (important to get the colorscheme right)
set bg=dark
" Tweak timeouts, because the default is too conservative
" This setting is taken from :h 'ttimeoutlen'
set timeout timeoutlen=3000 ttimeoutlen=100

" Turn on: show current mode, showmatching brackets, show additional info,
"          show always status line
set showmode showmatch wildmenu showcmd ls=2

" Search options: ignore case, increment search, no highlight, smart case
" nostartofline option
set incsearch nohlsearch smartcase nostartofline ignorecase
" show partial lines
set display+=lastline
" whichwrap those keys move the cursor to the next line if at the end of the line
set ww=<,>
" when using :scrollbind, also bind scrolling horizontally
set scrollopt+=hor
" English messages please
"lang C
"lang mess C
"lang ctype C
" how many entries in the commandline history to save
set history=1000
" Commandline Completion
set wildmode=list:longest,longest:full

" Tabstop settings
set ts=2
" the amount to indent when using ">>" or autoindent (zero means, follow
" 'tabstop' option)
set shiftwidth=0
" softtabstops make you feel, a tab is 4 spaces wide, instead the default
" 8. This means display utilities will still see 8 character wide tabs, 
" while in vim, a tab looks like 4 characters
" (-1 means, follow shiftwidth option)
set softtabstop=-1
" round indent to multiple of 'sw'
set shiftround
" Set backspace (BS): eol,indent,start and shell, decrease updatetime a bit
set bs=2 sh=zsh updatetime=1000

" Numberformat to use, unsetting bascially only allows decimal
" octal and hex may make trouble if tried to increment/decrement
" certain numberformats
" (e.g. 007 will be incremented to 010, because vim thinks its octal)
set nrformats=

" Breakindent
if exists('+breakindent')
  set bri
  set briopt=min:20,sbr
endif

" prevent langmap option from remapping the right side of a mapping
if exists('+langremap')
  set nolangremap
endif

" set dictionary. Press <CTRL>X <CTRL> K for looking up
" use german words, see debian package `wngerman'
set dictionary=/usr/share/dict/words

" change language -  get spell files from http://ftp.vim.org/pub/vim/runtime/spell/
" cd ~/.vim/spell && wget http://ftp.vim.org/pub/vim/runtime/spell/de.latin1.spl
" change to german:
set spelllang=de,en spellfile=~/.vim/spellfile.add
" set maximum number of suggestions listed to top 10 items
set sps=best,10

" Default for matchpairs: (:),[:],{:},<:>
set matchpairs+=<:>

if has("folding")
  set foldenable foldmethod=marker foldlevelstart=0
endif

" Store more items in the viminfo
set viminfo='100,<50,s10,h,!,:1000

"if exists("$PUTTY_TERM")
"    putty works mostly like xterm (in fact more features work OOTB
"    pretending to be an xterm compatible terminal (cursor keys, etc),
"    so use that one instead of putty-256color
"    exe "set t_ti=\e[?1049h t_te=\e[?1049l"
if &term =~ 'tmux'
  set t_Co=256
elseif (&term =~ '^screen')
  set t_Co=256
  set title
  "set t_ts=k
  "set t_fs=\
  set titlelen=15
  " set information for title in screen (see :h 'statusline')
  set titlestring=%t%=%<%(\ %{&encoding},[%{&modified?'+':'-'}],%p%%%)
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
"  set t_AB=^[[48;5;%dm
"  set t_AF=^[[38;5;%dm
"  mode dependent cursor (switches between block and thin bar)
"  only works in xterm?
"  let &t_ti.="\e[1 q"
"  let &t_SI.="\e[5 q"
"  let &t_EI.="\e[1 q"
"  let &t_te.="\e[0 q"
endif

if !empty(&t_ut)
  " see http://snk.tuxfamily.org/log/vim-256color-bce.html
  " Not neccessary? (see below
  let &t_ut=''
endif

if (&t_Co == 256) || (&t_Co == 88) || has("gui_running")
  "let g:solarized_termcolors=256
  colorscheme janah
else
  colorscheme desert
endif

" gnome terminal sucks
if (exists("$COLORTERM") && $COLORTERM is# 'gnome-terminal')
  set term=builtin_ansi
  set t_Co=256
  colorscheme molokai
endif

" Some highlighting options:
"
" Make VertSplit take the same background as Normal
hi! link VertSplit Normal
" Change the disturbing pink color for omnicompletion
hi Pmenu guibg=DarkRed
" highlight matching parens:
highlight MatchParen term=reverse ctermbg=7 guibg=cornsilk
if has("conceal")
  hi! link Conceal Normal
endif

" enable truecolor even in the terminal
" tmux does support true color mode (but not putty)
"if exists('+termguicolors')
"    set termguicolors
"    set t_8f=[38;2;%lu;%lu;%lum
"    set t_8b=[48;2;%lu;%lu;%lum
"endif

" In Diff-Mode turn off Syntax highlighting
if has("diff")
  if &diff
    syntax off
  endif
  " how to check, that enhanceddiff is actually installed?
  let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
endif

if has('persistent_undo')
  set undofile
  set undodir=~/.vim/undo/
endif

" Add ellipsis … to the digraphs
" this overwrite the default, but my current font won't display that
" letter anyway ;)
if has('digraphs')
  digraphs .3 8230
  digraphs \|- 166
endif

if &encoding == "utf-8"
  if !exists("$PUTTY_TERM") && $OS isnot# "Windows_NT"
    exe "set listchars=nbsp:\u2423,conceal:\u22ef,tab:\u2595\u2014,trail:\u02d1,precedes:\u2026,extends:\u2026,eol:\ub6"
    exe "set sbr=\u21b3"
  else
    " Putty can't display all nice utf-8 chars
    exe "set listchars=conceal:\u00b7,tab:>\u2014,trail:\u02d1,precedes:\u2026,extends:\u2026,eol:\ub6,nbsp:\u03c7"
    exe "set sbr=\u2500"
  endif
  exe "set fillchars=vert:\u2502,fold:\u2500,diff:\u2014"
else
  " Special characters that will be shown, when set list is on
  set listchars=eol:$,trail:-,tab:>-,extends:>,precedes:<,conceal:+
  " Display a `+' for wrapped lines
  set sbr=+
endif

if v:version > 704 || v:version == 704 && has("patch711")
  if !exists("$PUTTY_TERM") && $OS isnot# "Windows_NT"
    exe "set listchars+=space:\u2423"
  else
    exe "set listchars+=space:\ub7"
  endif
endif

" Shift-tab on GNU screen
" http://superuser.com/questions/195794/gnu-screen-shift-tab-issue
set t_kB=[Z

" In case /tmp get's clean out, make a new tmp directory for vim:
if has("user_commands")
  command! Mktmpdir call mkdir(fnamemodify(tempname(),":p:h"),"",0700)
  " Increase/Decrease GVims Fontsize
  command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
  command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')
endif

if has("autocmd")
  aug custom_BufRead
    au!
    au BufRead changes nmap ,cb o<CR>chrisbra, <ESC>:r!LC_ALL='' date<CR>kJo-
    " open file at last position (:h last-position-jump)
    au BufRead * if line("'\"") > 1 && line("'\"") <= line("$") && &filetype !=# 'gitcommit' | exe "normal! g`\"zvzz" | endif
  augroup END

  " highlight VCS conflict markers
  " highlight strange Whitespace
  aug CustomHighlighting
    au!
    au WinEnter * if !exists("w:custom_hi1") | let w:custom_hi1 = matchadd('ErrorMsg', '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$') | endif
    au WinEnter * if !exists("w:custom_hi2") | let w:custom_hi2 = matchadd('ErrorMsg', '[\x0b\x0c\u00a0\u1680\u180e\u2000-\u200a\u2028\u202f\u205f\u3000\ufeff]') |  endif
  aug END

  " if ctag or cscope open a file that is already opened elsewhere, make sure to
  " open it in Read-Only Mode
  " http://groups.google.com/group/vim_use/msg/5a1726ea0fd654d1
  if exists("##SwapExists")
    augroup Custom_Swap
      au!
      autocmd SwapExists * if v:swapcommand =~ '^:ta\%[g] \|^\d\+G$' | let v:swapchoice='o' | endif
    augroup END
  endif

  function! SetGuiFont()
    if has("gui_gtk") && !has("win32")
      let &guifont="Ubuntu Mono derivative Powerline 12"
      "set linespace=-1
    endif
  endfunction

  if !exists('#VimStartup#GuiEnter')
    augroup VimStartup
      au!
      autocmd GuiEnter * :call SetGuiFont()
    augroup end
  endif
endif

" skip for vim.tiny
if 1
  " This script contains plugin specific settings
  source ~/.vim/plugins.vim
  " This script contains mappings
  source ~/.vim/mapping.vim
  source ~/.vim/functions.vim

  " experimental and debug settings
  " (possibly not even available in vanilla vim)
  " source ~/.vim/experimental.vim

  " source matchit
  ru macros/matchit.vim

  " Special Search patterns:
  let g:SEARCH_VISUAL_END='\%(\%(\%V.*\%V.\)\@>\zs\(.\|$\)\)'
  " Search literally!
  com! -nargs=1 Search :let @/='\V'.escape(<q-args>, '\\')| normal! n

  " use better grep alternatives, if available
  if executable('ripgrep')
    set grepprg=ripgrep
  elseif executable('ag')
    set grepprg=ag
  elseif executable('sift')
    set grepprg=sift
  endif
endif

if has('cscope') && executable('cscope')
  set cscopetag cscopeverbose
  if has('quickfix')
    set cscopequickfix=s-,c-,d-,i-,t-,e-
  endif
endif

" vim:et sts=-1 ts=2 sw=0
