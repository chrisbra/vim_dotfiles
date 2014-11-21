" savesigns.vim - Vim global plugin for Saving Signs
" -------------------------------------------------------------
" Last Change: Mon, 19 Aug 2013 22:00:35 +0200


" Maintainer:  Christian Brabandt <cb@256bit.org>
" Version:     0.5
" Copyright:   (c) 2010 by Christian Brabandt
"              The VIM LICENSE applies to histwin.vim 
"              (see |copyright|) except use "savesigns.vim" 
"              instead of "Vim".
"              No warranty, express or implied.
"    *** ***   Use At-Your-Own-Risk!   *** ***
"
" GetLatestVimScripts: 2992 4 :AutoInstall: savesigns.vim
" TODO: - write documentation

" Init:"{{{
if exists("g:loaded_savesigns") || &cp || !has("signs")
  finish
endif

let g:loaded_savesigns   = 0.3
let s:cpo                = &cpo
set cpo&vim"}}}

" User_Command:"{{{
if exists(":SaveSigns") != 2
	com! -nargs=? -bang -complete=file SaveSigns 
	\:call savesigns#ParseSignsOutput(<q-args>, "<bang>")
else
	echoerr ":SaveSigns is already defined. May be by another Plugin?"
endif"}}}

" Restore:"{{{
let &cpo=s:cpo
unlet s:cpo"}}}

" ChangeLog:
" 0.3     - Enable GLVS (see :h GLVS)
" 0.2	  - Make autoload plugin
" 0.1     - First working version
" vim: ts=4 sts=4 fdm=marker com+=l\:\" spell spelllang=en fdm=marker
