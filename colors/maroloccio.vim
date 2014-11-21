" File        : maroloccio.vim
" Description : a colour scheme for Vim (GUI only)
" Scheme      : maroloccio
" Maintainer  : Marco Ippolito < m a r o l o c c i o [at] g m a i l . c o m >
" Comment     : works well in GUI mode
" Version     : v0.2.7, inspired by watermark
" Date        : 15 March 2009
"
" History:
"
" 0.2.7 Further improved readability of cterm colours
" 0.2.6 Improved readability of cterm colours on different terminals
" 0.2.5 Reinstated minimal cterm support
" 0.2.4 Added full colour descriptions and reinstated minimal cterm support
" 0.2.3 Added FoldColumn to the list of hlights as per David Hall's suggestion
" 0.2.2 Removed cterm support, changed visual highlight, fixed bolds
" 0.2.1 Changed search highlight
" 0.2.0 Removed italics
" 0.1.9 Improved search and menu highlighting
" 0.1.8 Added minimal cterm support
" 0.1.7 Uploaded to vim.org
" 0.1.6 Removed redundant highlight definitions
" 0.1.5 Improved display of folded sections
" 0.1.4 Removed linked sections for improved compatibility, more Python friendly
" 0.1.3 Removed settings which usually belong to .vimrc (as in 0.1.1)
" 0.1.2 Fixed versioning system, added .vimrc -like commands
" 0.1.1 Corrected typo in header comments, changed colour for Comment
" 0.1.0 Inital upload to vim.org

hi clear Normal
set background&
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name="maroloccio"
"set background=dark " FIXME

" --- GUI section
"
hi Normal         guifg=#8b9aaa guibg=#1a202a  gui=none                         " watermark-foreground on watermark-background
hi LineNr         guifg=#2c3138 guibg=#0e1219  gui=none                         " grey on dark grey
hi FoldColumn     guifg=#333366 guibg=#0e1219  gui=none                         " violet on dark grey
hi TabLine        guifg=fg      guibg=black    gui=none                         " foreground on black
hi StatusLine     guifg=fg      guibg=black    gui=none                         " foreground on black
hi StatusLineNC   guifg=#2c3138 guibg=black    gui=none                         " grey on black
hi WildMenu       guifg=fg      guibg=#0e1219  gui=none                         " foreground on dark grey
hi Folded         guifg=fg      guibg=#333366  gui=none                         " foreground on violet
hi VertSplit      guifg=fg      guibg=#333366  gui=none                         " foreground on violet
hi Visual         guifg=fg      guibg=#3741ad  gui=none                         " foreground on blue
hi Search         guifg=#78ba42 guibg=#107040  gui=none                         " light green on green
hi IncSearch      guifg=#0e1219 guibg=#82ade0  gui=bold                         " dark grey on cyan
hi Cursor         guifg=#0e1219 guibg=#8b9aaa  gui=none                         " dark grey on foreground
hi NonText        guifg=#333366 guibg=bg       gui=none                         " metal on background
hi SpecialKey     guifg=#333366 guibg=bg       gui=none                         " metal on background
hi Conditional    guifg=#ff9900 guibg=bg       gui=none                         " orange on background
hi Repeat         guifg=#78ba42 guibg=bg       gui=none                         " light green on background
hi String         guifg=#4c4cad guibg=bg       gui=none                         " violet on background
hi Number         guifg=#8b8b00 guibg=bg       gui=none                         " dark yellow on background
hi Constant       guifg=#82ade0 guibg=bg       gui=none                         " cyan on background
hi Character      guifg=#82ade0 guibg=bg       gui=none                         " cyan on background
hi Boolean        guifg=#82ade0 guibg=bg       gui=none                         " cyan on background
hi Float          guifg=#82ade0 guibg=bg       gui=none                         " cyan on background
hi Function       guifg=#ffcc00 guibg=bg       gui=none                         " yellow on background
hi Type           guifg=#ffcc00 guibg=bg       gui=none                         " yellow on background
hi StorageClass   guifg=#ffcc00 guibg=bg       gui=none                         " yellow on background
hi Structure      guifg=#ffcc00 guibg=bg       gui=none                         " yellow on background
hi Typedef        guifg=#ffcc00 guibg=bg       gui=none                         " yellow on background
hi PreProc        guifg=#107040 guibg=bg       gui=none                         " green on background
hi Include        guifg=#107040 guibg=bg       gui=none                         " green on background
hi Define         guifg=#107040 guibg=bg       gui=none                         " green on background
hi Macro          guifg=#107040 guibg=bg       gui=none                         " green on background
hi PreCondit      guifg=#107040 guibg=bg       gui=none                         " green on background
hi Todo           guifg=#8f3231 guibg=#0e1219  gui=bold,undercurl guisp=#cbc32a " red on dark grey
hi Exception      guifg=#8f3231 guibg=bg       gui=none                         " red on background
hi Title          guifg=#8f3231 guibg=bg       gui=none                         " red on background
hi Error          guifg=fg      guibg=#8f3231  gui=none                         " foreground on red
hi Statement      guifg=#9966cc guibg=bg       gui=none                         " lavender on background
hi Comment        guifg=#006666 guibg=bg       gui=none                         " teal on background
hi SpecialComment guifg=#2680af guibg=bg       gui=none                         " blue2 on background
hi Operator       guifg=#6d5279 guibg=bg       gui=none                         " pink on background
hi Special        guifg=#3741ad guibg=bg       gui=none                         " blue on background
hi SpecialChar    guifg=#3741ad guibg=bg       gui=none                         " blue on background
hi Tag            guifg=#3741ad guibg=bg       gui=none                         " blue on background
hi Delimiter      guifg=#3741ad guibg=bg       gui=none                         " blue on background
hi Label          guifg=#7e28a9 guibg=bg       gui=none                         " purple on background
hi Underlined                                  gui=bold,underline               " underline
if version>= 700
hi Pmenu          guifg=fg      guibg=#3741ad  gui=none                         " foreground on blue
hi PmenuSel       guifg=fg      guibg=#333366  gui=none                         " foreground on violet
hi CursorLine     guibg=#0e1219 gui=none                                        " foreground on dark grey
hi CursorColumn                 guibg=#0e1219  gui=none                         " foreground on dark grey
hi MatchParen     guifg=#0e1219 guibg=#78ba42  gui=none                         " dark grey on light green
endif

" --- CTerm (Dark)
"
if &background == "dark"
  hi Normal         ctermfg=Grey          "ctermbg=DarkGrey
  hi LineNr         ctermfg=DarkCyan      ctermbg=Black
  hi FoldColumn     ctermfg=Grey          ctermbg=Black
  hi TabLine        ctermfg=DarkGrey      ctermbg=Grey
  hi StatusLine     ctermfg=DarkGrey      ctermbg=Grey
  hi StatusLine     ctermfg=Brown         ctermbg=Black
  hi StatusLineNC   ctermfg=Grey          ctermbg=DarkGrey
  hi WildMenu       ctermfg=Grey          ctermbg=DarkGrey
  hi Folded         ctermfg=Black         ctermbg=DarkCyan
  hi VertSplit      ctermfg=Black         ctermbg=Brown
  hi Visual         ctermfg=Brown         ctermbg=Black
  hi Search         ctermfg=Grey          ctermbg=DarkGreen
  hi IncSearch      ctermfg=Brown         ctermbg=Black
  hi Cursor         ctermfg=Black         ctermbg=Grey
  hi NonText        ctermfg=DarkRed
  hi SpecialKey     ctermfg=DarkRed
  hi Conditional    ctermfg=Brown
  hi Repeat         ctermfg=Brown
  hi Function       ctermfg=Brown
  hi Type           ctermfg=Brown
  hi StorageClass   ctermfg=Brown
  hi Structure      ctermfg=Brown
  hi Typedef        ctermfg=Brown
  hi Statement      ctermfg=Brown
  hi Operator       ctermfg=Brown
  hi Exception      ctermfg=Brown
  hi Label          ctermfg=Brown
  hi Tag            ctermfg=Brown
  hi Delimiter      ctermfg=Brown
  hi Special        ctermfg=Brown
  hi SpecialChar    ctermfg=Brown
  hi Comment        ctermfg=DarkCyan
  hi SpecialComment ctermfg=DarkCyan
  hi String         ctermfg=DarkGreen
  hi Number         ctermfg=DarkGreen
  hi Constant       ctermfg=DarkGreen
  hi Character      ctermfg=DarkGreen
  hi Boolean        ctermfg=DarkGreen
  hi Float          ctermfg=DarkGreen
  hi PreProc        ctermfg=DarkMagenta
  hi Include        ctermfg=DarkMagenta
  hi Define         ctermfg=DarkMagenta
  hi Macro          ctermfg=DarkMagenta
  hi PreCondit      ctermfg=DarkMagenta
  hi Todo           ctermfg=DarkRed       ctermbg=DarkGrey
  hi Error          ctermfg=Grey          ctermbg=DarkRed
  hi Underlined     cterm=Underline
  hi Title          ctermfg=DarkRed
  if version>= 700
    hi Pmenu        ctermfg=Grey          ctermbg=DarkBlue
    hi PmenuSel     ctermfg=DarkBlue      ctermbg=Grey
    hi CursorLine   cterm=Underline
    hi CursorColumn ctermfg=Grey          ctermbg=Black
    hi MatchParen   ctermfg=Grey          ctermbg=Green
  endif

" --- CTerm (Light)
"
else
  hi Normal         ctermfg=Black         ctermbg=White
  hi NonText        ctermfg=Red
  hi SpecialKey     ctermfg=Red
  hi Conditional    ctermfg=DarkBlue
  hi Repeat         ctermfg=DarkBlue
  hi Function       ctermfg=DarkBlue
  hi Type           ctermfg=DarkBlue
  hi StorageClass   ctermfg=DarkBlue
  hi Structure      ctermfg=DarkBlue
  hi Typedef        ctermfg=DarkBlue
  hi Statement      ctermfg=DarkBlue
  hi Operator       ctermfg=DarkBlue
  hi Exception      ctermfg=DarkBlue
  hi Label          ctermfg=DarkBlue
  hi Tag            ctermfg=DarkBlue
  hi Delimiter      ctermfg=DarkBlue
  hi Special        ctermfg=DarkBlue
  hi SpecialChar    ctermfg=DarkBlue
  hi String         ctermfg=DarkRed
  hi Character      ctermfg=DarkCyan
  hi Number         ctermfg=DarkCyan
  hi Constant       ctermfg=DarkCyan
  hi Boolean        ctermfg=DarkCyan
  hi Float          ctermfg=DarkCyan
  hi PreProc        ctermfg=DarkMagenta
  hi Include        ctermfg=DarkMagenta
  hi Define         ctermfg=DarkMagenta
  hi Macro          ctermfg=DarkMagenta
  hi PreCondit      ctermfg=DarkMagenta
  hi Comment        ctermfg=DarkGreen
  hi SpecialComment ctermfg=DarkGreen
  hi LineNr         ctermfg=Black         ctermbg=Grey
  hi Visual         ctermfg=Brown         ctermbg=Black
  hi Search         ctermfg=Grey          ctermbg=DarkGreen
  hi IncSearch      ctermfg=Brown         ctermbg=Black
  hi Folded         ctermfg=Black         ctermbg=DarkCyan
  hi Cursor         ctermfg=Black         ctermbg=Grey
  hi Todo           ctermfg=Grey          ctermbg=DarkRed
  hi Error          ctermfg=Grey          ctermbg=DarkRed
  hi FoldColumn     ctermfg=Black         ctermbg=Grey
  hi VertSplit      ctermfg=Grey          ctermbg=Black
  hi Underlined     cterm=Underline
  hi Title          ctermfg=DarkRed
  if version>= 700
    hi CursorLine   cterm=Underline
    hi CursorColumn ctermfg=Black         ctermbg=Grey
    hi Pmenu        ctermfg=Grey          ctermbg=DarkBlue
    hi PmenuSel     ctermfg=DarkBlue      ctermbg=Grey
    hi MatchParen   ctermfg=Grey          ctermbg=Green
  endif
  hi StatusLine     ctermfg=Grey          ctermbg=Black
  hi StatusLineNC   ctermfg=Grey          ctermbg=DarkBlue
  hi TabLine        ctermfg=DarkBlue      ctermbg=Grey
  hi WildMenu       ctermfg=Grey          ctermbg=DarkBlue
endif
