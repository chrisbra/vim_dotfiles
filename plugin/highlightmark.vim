" Vim plugin for visual highlighting marks
" Maintainer: Christian Brabandt <cb@256bit.org>
" Last Change: 2008-02-14
" Last Version: 0.6

" Configuration"{{{
" Exit quickly when:"{{{
" - this plugin was already loaded
" - when 'compatible' is set
if exists("b:loaded_himarks") || &cp
  finish
endif
let b:loaded_himarks = 1"}}}

" Define Highlighting group"{{{
" see :hi for possible values
let s:higrp="SignColumn""}}}

" Enable/Disable via the following key"{{{
let s:key="<f6>""}}}

" Enabling the autocommand will automatically highlight"{{{
" existing marks (especially global ones) when loading the
" file
" 0 disabled (false)
" 1 enabled  (true)
let s:EnableAutoCommand=0"}}}

" Which marks to highlight"{{{
" local Marks can range from a-z, []<>.
" global Marks can range from A-Z0-9
let s:marks="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
let s:all_marks = split(s:marks, '\zs')"}}}

" Version Number"{{{
let s:version = "0.6""}}}

" Start Identifier for signs"{{{
let s:id=100"}}}

" Check Preconditions"{{{
if version < 700 
	let v:errmsg = "The script" . expand("%:t") . " plugin requires Vim version > 7. Exiting ...."
	echo v:errmsg
	finish
elseif !has("signs")
	let v:errmsg = "The script" . expand("%:t") . " requires that vim is compiled with +signs. Exiting ...."
	echo v:errmsg
	finish
endif"}}}"}}}

" Function Definitions"{{{

function! s:HighlightMark(key)"{{{
	exe "norm! m".a:key
	call s:DoHighlightMarks()
endfunction"}}}

" This function actually does the highlighting
" of the marks
function! s:DoHighlightMarks()"{{{
	let curbufnr = bufnr('%')
	let id=s:id
	for i in s:all_marks
		let pos=getpos("'".i)
		if ((pos[1]==0 && pos[2]==0) || pos[0] != curbufnr && pos[0] != 0)
			" mark not defined in this buffer
			continue
		endif
		
		" Remove previously defined signs by this function
		exe "silent! sign unplace id"
		exe "silent! sign undefine mark".i

		" Define and Place Signs
		exe "sign define mark" .i. " text='" . i . " texthl=".s:higrp
		exe "sign place ". id ." line=" . pos[1] . " name=mark". i . " buffer=".bufnr('%')
		let id+=1
	endfor
	redraw!
endfunction"}}}

function! s:RemoveHiMarks()"{{{
	let id=s:id
	let curbufnr = bufnr('%')
	for i in s:all_marks
		let pos=getpos("'".i)
		if ((pos[1]==0 && pos[2]==0) || pos[0] != curbufnr && pos[0] != 0)
			" mark not defined
			continue
		endif
		
		" Remove previously defined signs by this function
		exe "silent! sign unplace " . id . " buffer=" . bufnr('%')
		exe "silent! sign undefine mark".i
		let id+=1
	endfor
	redraw!
endfunction"}}}

" Map or unmap m to the highlighting Function
function! s:MapFunctionMarks(val)"{{{
	let l:map = a:val 
\	?  'nnoremap <silent><buffer> m :call <SID>HighlightMark(nr2char(getchar()))<CR>'
\	:  'unm <buffer> m'
	exe l:map
endfunction"}}}

function! s:ToggleHiMarks()"{{{
	if !exists("b:ToggleHiMarksVar") || ((b:ToggleHiMarksVar < 0) || (b:ToggleHiMarksVar > 1))
		let b:ToggleHiMarksVar = 1
	endif
	if (b:ToggleHiMarksVar)
		" Now remap m to set marks and execute the function to highlight the marks
		silent! call s:MapFunctionMarks(1)
		silent! call s:DoHighlightMarks()
		if (s:EnableAutoCommand)
			augroup himark
				au!
				au! BufReadPost * :call <SID>DoHighlightMarks()
			augroup END
		endif
	else
		silent! call s:RemoveHiMarks()
		silent! call s:MapFunctionMarks(0)
		silent! call s:RemoveHiMarks()
		silent! augroup!  himark
	endif
	let b:ToggleHiMarksVar = !b:ToggleHiMarksVar
endfu"}}}

function! s:WriteVariables()"{{{
	let curpos = getpos(".")
	call cursor(1,1)
	call search('Last Change: ', 'ce')
	let timestamp=strftime("%Y-%m-%d")
	normal D
	put =timestamp
	normal kJ
	call search('Last Version: ', 'ce')
	normal D
	put =s:version
	normal kJ
	call setpos(".",curpos)
endfu"}}}"}}}

" Setup Mapping "{{{
exe 'nmap <silent> '.s:key.' :call <SID>ToggleHiMarks()<CR>' 
"}}}

" Modeline and buffer-local Autocommand {{{1
"au BufWrite <buffer> :call <SID>WriteVariables()
" vim: set fdm=marker fdl=0 :  }}}
