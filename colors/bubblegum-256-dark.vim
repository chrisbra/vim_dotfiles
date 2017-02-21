" Bubblegum 256 Dark
"  Author: baskerville <nihilhill@gmail.com>
"     URL: github.com/baskerville/bubblegum
" Created: 2011
" Version: 0.3

hi clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name="bubblegum-256-dark"


" Main
hi Normal ctermfg=249 ctermbg=235 cterm=none guifg=#B2B2B2 guibg=#262626 gui=none
hi Comment ctermfg=244 ctermbg=235 cterm=none guifg=#808080 guibg=#262626 gui=none

" Constant
hi Constant ctermfg=186 ctermbg=235 cterm=none guifg=#D7D787 guibg=#262626 gui=none
hi String ctermfg=187 ctermbg=235 cterm=none guifg=#D7D7AF guibg=#262626 gui=none
hi Character ctermfg=187 ctermbg=235 cterm=none guifg=#D7D7AF guibg=#262626 gui=none
hi Number ctermfg=180 ctermbg=235 cterm=none guifg=#D7AF87 guibg=#262626 gui=none
hi Boolean ctermfg=187 ctermbg=235 cterm=none guifg=#D7D7AF guibg=#262626 gui=none
hi Float ctermfg=180 ctermbg=235 cterm=none guifg=#D7AF87 guibg=#262626 gui=none

" Variable Name
hi Identifier ctermfg=182 ctermbg=235 cterm=none guifg=#D7AFD7 guibg=#262626 gui=none
hi Function ctermfg=182 ctermbg=235 cterm=none guifg=#D7AFD7 guibg=#262626 gui=none

" Statement
hi Statement ctermfg=110 ctermbg=235 cterm=none guifg=#87AFD7 guibg=#262626 gui=none
hi Conditional ctermfg=110 ctermbg=235 cterm=none guifg=#87AFD7 guibg=#262626 gui=none
hi Repeat ctermfg=110 ctermbg=235 cterm=none guifg=#87AFD7 guibg=#262626 gui=none
hi Label ctermfg=110 ctermbg=235 cterm=none guifg=#87AFD7 guibg=#262626 gui=none
hi Operator ctermfg=110 ctermbg=235 cterm=none guifg=#87AFD7 guibg=#262626 gui=none
hi Keyword ctermfg=110 ctermbg=235 cterm=none guifg=#87AFD7 guibg=#262626 gui=none
hi Exception ctermfg=110 ctermbg=235 cterm=none guifg=#87AFD7 guibg=#262626 gui=none

" Preprocessor
hi PreProc ctermfg=150 ctermbg=235 cterm=none guifg=#AFD787 guibg=#262626 gui=none
hi Include ctermfg=150 ctermbg=235 cterm=none guifg=#AFD787 guibg=#262626 gui=none
hi Define ctermfg=150 ctermbg=235 cterm=none guifg=#AFD787 guibg=#262626 gui=none
hi Macro ctermfg=150 ctermbg=235 cterm=none guifg=#AFD787 guibg=#262626 gui=none
hi PreCondit ctermfg=150 ctermbg=235 cterm=none guifg=#AFD787 guibg=#262626 gui=none

" Type
hi Type ctermfg=146 ctermbg=235 cterm=none guifg=#AFAFD7 guibg=#262626 gui=none
hi StorageClass ctermfg=146 ctermbg=235 cterm=none guifg=#AFAFD7 guibg=#262626 gui=none
hi Structure ctermfg=146 ctermbg=235 cterm=none guifg=#AFAFD7 guibg=#262626 gui=none
hi Typedef ctermfg=146 ctermbg=235 cterm=none guifg=#AFAFD7 guibg=#262626 gui=none

" Special
hi Special ctermfg=174 ctermbg=235 cterm=none guifg=#D78787 guibg=#262626 gui=none
hi SpecialChar ctermfg=174 ctermbg=235 cterm=none guifg=#D78787 guibg=#262626 gui=none
hi Tag ctermfg=174 ctermbg=235 cterm=none guifg=#D78787 guibg=#262626 gui=none
hi Delimiter ctermfg=174 ctermbg=235 cterm=none guifg=#D78787 guibg=#262626 gui=none
hi SpecialComment ctermfg=174 ctermbg=235 cterm=none guifg=#D78787 guibg=#262626 gui=none
hi Debug ctermfg=174 ctermbg=235 cterm=none guifg=#D78787 guibg=#262626 gui=none
hi Underlined ctermfg=249 ctermbg=235 cterm=underline guifg=#B2B2B2 guibg=#262626 gui=underline
hi Ignore ctermfg=235 ctermbg=235 cterm=none guifg=#262626 guibg=#262626 gui=none
hi Error ctermfg=231 ctermbg=167 cterm=none guifg=#FFFFFF guibg=#D75F5F gui=none
hi Todo ctermfg=244 ctermbg=235 cterm=none guifg=#808080 guibg=#262626 gui=none

" Window
hi StatusLine ctermfg=249 ctermbg=237 cterm=none guifg=#B2B2B2 guibg=#3A3A3A gui=none
hi StatusLineNC ctermfg=244 ctermbg=237 cterm=none guifg=#808080 guibg=#3A3A3A gui=none
hi TabLine ctermfg=249 ctermbg=237 cterm=none guifg=#B2B2B2 guibg=#3A3A3A gui=none
hi TabLineSel ctermfg=253 ctermbg=238 cterm=none guifg=#DADADA guibg=#444444 gui=none
hi TabLineFill ctermbg=237 cterm=none guibg=#3A3A3A gui=none
hi VertSplit ctermfg=237 ctermbg=237 cterm=none guifg=#3A3A3A guibg=#3A3A3A gui=none

" Menu
hi Pmenu ctermfg=249 ctermbg=237 cterm=none guifg=#B2B2B2 guibg=#3A3A3A gui=none
hi PmenuSel ctermfg=231 ctermbg=244 cterm=none guifg=#FFFFFF guibg=#808080 gui=none
hi PmenuSbar ctermbg=59 cterm=none guibg=#5F5F5F gui=none
hi PmenuThumb ctermbg=246 cterm=none guibg=#949494 gui=none
hi WildMenu ctermfg=232 ctermbg=98 cterm=none guifg=#080808 guibg=#875FD7 gui=none

" Selection
hi Visual ctermfg=235 ctermbg=117 cterm=none guifg=#262626 guibg=#87D7FF gui=none
hi VisualNOS ctermfg=235 ctermbg=80 cterm=none guifg=#262626 guibg=#5FD7D7 gui=none

" Message
hi ErrorMsg ctermfg=210 ctermbg=235 cterm=none guifg=#FF8787 guibg=#262626 gui=none
hi WarningMsg ctermfg=140 ctermbg=235 cterm=none guifg=#AF87D7 guibg=#262626 gui=none
hi MoreMsg ctermfg=72 ctermbg=235 cterm=none guifg=#5FAF87 guibg=#262626 gui=none
hi ModeMsg ctermfg=222 ctermbg=235 cterm=bold guifg=#FFD787 guibg=#262626 gui=bold
hi Question ctermfg=38 ctermbg=235 cterm=none guifg=#00AFD7 guibg=#262626 gui=none

" Mark
hi Folded ctermfg=244 ctermbg=235 cterm=none guifg=#808080 guibg=#262626 gui=none
hi FoldColumn ctermfg=79 ctermbg=237 cterm=none guifg=#5FD7AF guibg=#3A3A3A gui=none
hi SignColumn ctermfg=184 ctermbg=237 cterm=none guifg=#D7D700 guibg=#3A3A3A gui=none
