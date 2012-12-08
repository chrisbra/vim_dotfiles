" ChangesPlugin.vim - Using Signs for indicating changed lines
" ---------------------------------------------------------------
" Version:  0.12
" Authors:  Christian Brabandt <cb@256bit.org>
" Last Change: Tue, 31 Jan 2012 22:07:31 +0100


" Script:  http://www.vim.org/scripts/script.php?script_id=3052
" License: VIM License
" Documentation: see :help changesPlugin.txt
" GetLatestVimScripts: 3052 12 :AutoInstall: ChangesPlugin.vim


" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_changes")
 finish
endif
let g:loaded_changes       = 1
let s:keepcpo              = &cpo
set cpo&vim

let s:autocmd  = (exists("g:changes_autocmd")  ? g:changes_autocmd  : 0)
" ------------------------------------------------------------------------------
" Public Interface: {{{1

" Define the Shortcuts:
com! -nargs=? -complete=file EC	 EnableChanges <args>
com! DC	 DisableChanges
com! TCV ToggleChangeView
com! CC  ChangesCaption
com! CL  ChangesLinesOverview
com! CD  ChangesDiffMode

com! -nargs=? -complete=file EnableChanges	call changes#GetDiff(1,<q-args>)
com! DisableChanges		call changes#CleanUp()
com! ToggleChangeView		call changes#TCV()
com! ChangesCaption		call changes#Output(1)
com! ChangesLinesOverview	call changes#GetDiff(2)
com! ChangesDiffMode		call changes#GetDiff(3)

if s:autocmd
    exe "call changes#Init()"
endif
" =====================================================================
" Restoration And Modelines: {{{1
" vim: fdm=marker
let &cpo= s:keepcpo
unlet s:keepcpo

" Modeline
" vi:fdm=marker fdl=0
