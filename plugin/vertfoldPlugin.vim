" vertfold.vim - Vertical folding plugin for Vim
" -------------------------------------------------------------
" Version:	   0.1
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Last Change: Fri, 10 Dec 2010 15:16:29 +0100
"
" Script: http://www.vim.org/scripts/script.php?script_id=????
" Copyright:   (c) 2009, 2010, 2011 by Christian Brabandt
"			   The VIM LICENSE applies to vertfold.vim 
"			   (see |copyright|) except use "vertfold.vim" 
"			   instead of "Vim".
"			   No warranty, express or implied.
"	 *** ***   Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts: ???? 1 :AutoInstall: vertfold.vim
" Init: {{{1
let s:cpo= &cpo
if exists("g:loaded_vertfold") || &cp
  finish
endif
" Check for the ability to conceal
if !has("conceal")
  redraw
  echohl Error
  echomsg "vertfold: Your Vim does not support concealing of items!"
  echomsg "Vertical folding not enabled!"
  echohl Normal
endif
set cpo&vim
let g:loaded_vertfold = 1

" ------------------------------------------------------------------------------
" Public Interface: {{{1

" Define the Mapping: "{{{2
if !hasmapto('<Plug>FoldCol')
	xmap <unique> <Leader>vf <Plug>FoldCol
endif
xnoremap <unique> <script> <Plug>FoldCol <sid>VertFoldCol
xnoremap <sid>VertFoldCol :<c-u>call vertfold#VertFoldCol()<cr>

" Define the commands "{{{2
com! -nargs=1 VFP :call vertfold#VertFoldPat(<q-args>)
com! VFClear	 :call  vertfold#VertFoldClear()

" Restore: "{{{1
let &cpo=s:cpo
unlet s:cpo
" vim: ts=4 sts=4 fdm=marker com+=l\:\"
