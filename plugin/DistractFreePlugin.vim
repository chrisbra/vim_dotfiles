" DistractFreePlugin - Plugin for creating WriteRoom like state in Vim
" -------------------------------------------------------------
" Version:      0.5
" Maintainer:   Christian Brabandt <cb@256bit.org>
" Last Change: Wed, 14 Aug 2013 22:36:39 +0200
" Script:       http://www.vim.org/scripts/script.php?script_id=
" Copyright:    (c) 2009, 2010, 2011, 2012 by Christian Brabandt
"
"       The VIM LICENSE applies to DistractFree.vim
"       (see |copyright|) except use "DistractFree.vim"
"       instead of "Vim".
"       No warranty, express or implied.
"       *** *** Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts: 4357 5 :AutoInstall: DistractFree.vim

" Init: "{{{1
let s:cpo= &cpo
if exists("g:loaded_distract_free") || &cp
  finish
endif
set cpo&vim

" Parse Version line
let g:loaded_distract_free = matchstr(getline(3), '\.\zs\d\+') + 0

" Define the Commands " {{{2
command! -nargs=0 DistractFreeToggle call DistractFree#DistractFreeToggle()

" Define the Mapping: "{{{2
noremap <silent> <Plug>DistractFreeToggle    :DistractFreeToggle<CR>
" If no mapping exists, map it to `<Leader>W`.
if !hasmapto( '<Plug>DistractFreeToggle' )
    nmap <silent> <Leader>W <Plug>DistractFreeToggle
endif

" Restore: "{{{1
let &cpo=s:cpo
unlet s:cpo
" vim: ts=4 sts=4 fdm=marker et com+=l\:\"
