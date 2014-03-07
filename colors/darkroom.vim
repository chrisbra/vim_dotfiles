" Vim WriteRoom/DarkRoom/OmniWrite like colorscheme
" Maintainer:   Christian Brabandt <cb@256bit.org>
" Last Change:  2012

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="distractfree"

hi Statement    ctermfg=DarkCyan    ctermbg=Black	guifg=DarkCyan      guibg=Black
hi Constant     ctermfg=DarkCyan    ctermbg=Black     	guifg=DarkCyan	    guibg=Black
hi Identifier   ctermfg=Green	    ctermbg=Black     	guifg=Green	    guibg=Black
hi Type         ctermfg=DarkCyan    ctermbg=Black     	guifg=DarkCyan	    guibg=Black
hi String       ctermfg=Cyan	    ctermbg=Black     	guifg=Cyan	    guibg=Black
hi Boolean      ctermfg=DarkCyan    ctermbg=Black     	guifg=DarkCyan	    guibg=Black
hi Number       ctermfg=DarkCyan    ctermbg=Black     	guifg=DarkCyan	    guibg=Black
hi Special      ctermfg=DarkGreen   ctermbg=Black     	guifg=darkGreen     guibg=Black
hi Scrollbar    ctermfg=DarkCyan    ctermbg=Black     	guifg=DarkCyan      guibg=Black
hi Cursor       ctermfg=Black	    ctermbg=Green     	guifg=Black	    guibg=Green
hi WarningMsg   ctermfg=Yellow	    ctermbg=Black	guifg=Yellow	    guibg=Black
hi Directory    ctermfg=Green	    ctermbg=DarkBlue	guifg=Green	    guibg=DarkBlue
hi Title        ctermfg=White	    ctermbg=DarkBlue	guifg=White	    guibg=DarkBlue 
hi Cursorline   ctermfg=Black	    ctermbg=DarkGreen	guibg=darkGreen	    guifg=black
hi Normal       ctermfg=Green	    ctermbg=Black	guifg=Green	    guibg=Black
hi PreProc      ctermfg=DarkGreen   ctermbg=Black     	guifg=DarkGreen	    guibg=Black
hi Comment      ctermfg=darkGreen   ctermbg=Black     	guifg=darkGreen	    guibg=Black
hi LineNr       ctermfg=Green	    ctermbg=Black	guifg=Green	    guibg=Black
hi ErrorMsg     ctermfg=Red	    ctermbg=Black     	guifg=Red	    guibg=Black
hi Visual       ctermfg=White	    ctermbg=DarkGray	cterm=underline	    guifg=White		guibg=DarkGray	gui=underline
hi Folded       ctermfg=DarkCyan    ctermbg=Black     	cterm=underline	    guifg=DarkCyan	guibg=Black	gui=underline

" Reset by distract free
" hi NonText      ctermfg=Black  ctermbg=Black guifg=black  guibg=Black
" hi VertSplit    ctermfg=Black     ctermbg=Black guifg=black     guibg=Black
" hi StatusLine   cterm=bold,underline ctermfg=White ctermbg=Black term=bold gui=bold,underline guifg=White guibg=Black
" hi StatusLineNC cterm=bold,underline ctermfg=Gray  ctermbg=Black term=bold gui=bold,underline guifg=Gray  guibg=Black 
