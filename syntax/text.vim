" disabled:
finish
sy spell toplevel
sy sync fromstart

sy match textFirstLine  /\%^.*/ nextgroup=textEvenLine
sy match textOddLine  /^.*\n/ nextgroup=textEvenLine
sy match textEvenLine /^.*\n/ nextgroup=textOddLine

if &bg == "light"
      hi def textFirstLine  guibg=#FFFFCC ctermbg=darkmagenta
      hi def textOddLine  guibg=#FFFFCC ctermbg=darkmagenta
      hi def textEvenLine guibg=#FFCCFF ctermbg=darkblue
else
      hi def textFirstLine  guibg=#FFFFCC ctermbg=darkmagenta
      hi def textOddLine  guibg=#666600 ctermbg=darkmagenta
      hi def textEvenLine guibg=#660066 ctermbg=darkblue
endif

let b:current_syntax = "text"
