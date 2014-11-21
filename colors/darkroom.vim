" Vim WriteRoom/DarkRoom/OmniWrite like colorscheme
" Maintainer:   Christian Brabandt <cb@256bit.org>
" Last Change:  2012

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="darkroom"

let ctermbg=(get(g:, 'distractfree_transparent_cterm', 0) ? 'NONE' : 'Black')

fu! <sid>Hi(group, properties)
    exe ':hi' a:group a:properties
endfu

for group in ['Statement', 'Constant', 'Type', 'Boolean', 'Number', 'Scrollbar']
    call <sid>Hi(group, 'ctermfg=DarkCyan ctermbg='.ctermbg.' guifg=DarkCyan guibg=Black')
endfor

for group in ['Special', 'PreProc', 'Comment']
    call <sid>Hi(group, 'ctermfg=DarkGreen ctermbg='.ctermbg.' guifg=DarkGreen guibg=Black')
endfor

for group in ['Identifier', 'Normal', 'LineNr']
    call <sid>Hi(group, 'ctermfg=Green ctermbg='.ctermbg.' guifg=Green guibg=Black')
endfor

call <sid>Hi('VertSplit', 'ctermfg=Green    ctermbg='.ctermbg.' guibg=Black guifg=NONE gui=NONE')
call <sid>Hi('Cursorline', 'ctermfg=Black    ctermbg='.ctermbg.' guibg=DarkGreen guifg=Black')
call <sid>Hi('Folded',     'ctermfg=DarkCyan ctermbg='.ctermbg.' cterm=underline guifg=DarkCyan guibg=Black gui=underline')
call <sid>Hi('ErrorMsg',   'ctermfg=Red      ctermbg='.ctermbg.' guibg=Black guifg=Red')
call <sid>Hi('WarningMsg', 'ctermfg=Yellow   ctermbg='.ctermbg.' guibg=Black guifg=Yellow')
call <sid>Hi('String',     'ctermfg=Cyan     ctermbg='.ctermbg.' guibg=Black guifg=Cyan')
call <sid>Hi('SignColumn', 'ctermfg=Yellow   ctermbg='.ctermbg.' guibg=Black guifg=Yellow')

hi Directory    ctermfg=Green       ctermbg=DarkBlue    guifg=Green         guibg=DarkBlue
hi Cursor       ctermfg=Black       ctermbg=Green       guifg=Black         guibg=Green
hi Title        ctermfg=White       ctermbg=DarkBlue    guifg=White         guibg=DarkBlue 
hi Visual       ctermfg=White       ctermbg=DarkGray    cterm=underline     guifg=White         guibg=DarkGray  gui=underline

" link some highlight groups
hi! link NonText Ignore

" Make sure bg is still dark (might have been reset after setting the Normal group
set background=dark

" Reset by distract free
" hi NonText      ctermfg=Black  ctermbg=Black guifg=black  guibg=Black
" hi VertSplit    ctermfg=Black     ctermbg=Black guifg=black     guibg=Black
" hi StatusLine   cterm=bold,underline ctermfg=White ctermbg=Black term=bold gui=bold,underline guifg=White guibg=Black
" hi StatusLineNC cterm=bold,underline ctermfg=Gray  ctermbg=Black term=bold gui=bold,underline guifg=Gray  guibg=Black 
