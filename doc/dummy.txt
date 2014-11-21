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
"
" Functions:

fun! <sid>WarningMsg(msg) "{{{1
	let msg = "VertFold: " . a:msg
	echohl WarningMsg
	if exists(":unsilent") == 2
		unsilent echomsg msg
	else
		echomsg msg
	endif
	sleep 1
	echohl Normal
	let v:errmsg = msg
endfun

fun! <sid>Init() "{{{1
	if !has("conceal")
		call <sid>WarningMsg("Your vim does not support concealing of items!")
		throw "vertfold:return"
	endif
	" check the value of conceallevel
	if !&cole
		setl cole=2 cocu=nc
	endif
	" Customizations
	" Character to show instead of the folded text
	let s:cchar='+'
endfu!

fun! vertfold#VertFoldCol() "{{{1
	try 
		call <sid>Init()
	catch /vertfold:return/
		return 1
	endtry
	let vstart	 =	 getpos("'<")[1:2]
	let vend	 =	 getpos("'>")[1:2]
	if vend[1] == pow(2,31)-1
		let vend[1] = col('$')
	endif
	call <sid>WarningMsg("Concealing columns " . vstart[1] . " - "  . vend[1])
	let pat		 =	 '/\%' . vstart[1] . 'c.*\%' . vend[1] . 'c/'
	call <sid>SynConceal(pat)
endfun

fun! vertfold#VertFoldPat(pat) "{{{1
	try 
		call <sid>Init()
		let tpat = substitute(pat, '^\(.\)\(.*\)\1$', '\2', '')
		if tpat = pat
			throw "vertfold:E684"
		endif
	catch /vertfold:return/
		return 1
    catch /vertfold:E684/	" catch error index out of bounds
		call <sid>WarningMsg("Error! Usage :VFold /pattern/")
		return 1
	endtry
	call <sid>WarningMsg("Concealing pattern " . a:pat)
	let pat		 =	 '/' . a:pat . '/'
	call <sid>SynConceal(pat)
endfun

fun! vertfold#VertFoldClear() "{{{1
	syn enable
	" Is this really necessary?
	"redir=>a | silent syn | redir end
	"if a=="No Syntax items defined for this buffer"
	"	syn off
	"endif
	"hi clear VertFoldCol
endfun

fun! <sid>SynConceal(pattern) "{{{1
	if !exists("s:items")
		let s:items=1
	else
		let s:items+=1
	endif
	"exe 'syn match VertFoldCol' . s:items . ' ' .  a:pattern 'transparent conceal contains=ALL cchar=' . s:cchar
	exe "syn match VertFoldCol" a:pattern "transparent conceal contains=ALL cchar=" . s:cchar
endfun

" Modeline {{{1
" vim: ts=4 sts=4 fdm=marker com+=l\:\" fdl=0
