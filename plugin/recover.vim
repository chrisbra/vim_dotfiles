" Vim plugin for diffing when swap file was found
" Last Change: Wed, 21 Nov 2012 22:23:21 +0100
" Version: 0.16
" Author: Christian Brabandt <cb@256bit.org>
" Script:  http://www.vim.org/scripts/script.php?script_id=3068 
" License: VIM License
" GetLatestVimScripts: 3068 15 :AutoInstall: recover.vim
" Documentation: see :h recoverPlugin.txt

" ---------------------------------------------------------------------
" Load Once: {{{1
if exists("g:loaded_recover") || &cp
  finish
endif
let g:loaded_recover = 1"}}}
let s:keepcpo          = &cpo
set cpo&vim

" ---------------------------------------------------------------------
" Public Interface {{{1
" Define User-Commands and Autocommand "{{{
call recover#Recover(1)

com! RecoverPluginEnable :call recover#Recover(1)
com! RecoverPluginDisable :call recover#Recover(0)
com! RecoverPluginHelp   :call recover#Help()

" =====================================================================
" Restoration And Modelines: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo

" Modeline {{{1
" vim: fdm=marker sw=2 sts=2 ts=8 fdl=0
