" savesigns.vim - Vim global plugin for saving Signs
" -------------------------------------------------------------
" Last Change: Mon, 19 Aug 2013 22:00:35 +0200


" Maintainer:  Christian Brabandt <cb@256bit.org>
" Version:     0.5
" Copyright:   (c) 2009 by Christian Brabandt
"              The VIM LICENSE applies to histwin.vim 
"              (see |copyright|) except use "savesigns.vim" 
"              instead of "Vim".
"              No warranty, express or implied.
"    *** ***   Use At-Your-Own-Risk!   *** ***
"
" TODO: - write documentation

" Init:
let s:cpo= &cpo
set cpo&vim

fu! <sid>Output(mess, hi)"{{{
    exe "echohl" a:hi
    echomsg a:mess
    sleep 2
    echohl "Normal"
endfu"}}}

fu! savesigns#ParseSignsOutput(...)
    if !has("signs")
       call <sid>Output("Aborting, because your vim does not support Signs", "ErrorMsg")
       return
    endif

    let s:signs=[]
    let s:signdict={}

    " Get Highlighting of SignColumn
    redir => a
	sil hi SignColumn
    redir end

    let hi=split(a, '\n')[0]
    let hi=substitute(hi, "^", "hi! ", "")
    let hi=substitute(hi, '\s\+xxx\s\+', " ", "")
    let s:signs = [ '" Highlighting Definition of Signs',
		  \ hi,
		  \  '']


    " Get Definition of Signs
    redir => a
	sil sign list
    redir end

    call add(s:signs, '" Define Signs')
    let s:signs += split(a, '\n')
    call map(s:signs, 'substitute(v:val, "^sign", "& define", "")')
    let s:signs += [ '', '" Define Placement of Signs' ]


    " Get placement of signs
    redir => a
	sil sign place
    redir end

    let list=split(a, '\n')[1:]
    call filter(list, "!empty(v:val)")
    let fname=""
    let pat='^Signs for \zs.*\ze:'
    for val in list
	if match(val, pat) >= 0
	    let fname=fnamemodify(matchstr(val, pat), ':p')
	    let s:signdict[fname]=[]
	else
	    let place=split(val, '\s\+')
            if place[2] =~ '\[Deleted\]'
		continue
	    endif
	    call add(s:signdict[fname], "\tsign place " . matchstr(place[1],'id=\zs.*')  . " " . place[0] . " " . place[2] . " file=".fname )
	endif
    endfor
    for file in keys(s:signdict)
	call insert(s:signdict[file], "if bufexists('" . file . "')")
	call add(s:signdict[file], "endif")
    endfor
    call <sid>CreateSignFiles(empty(a:1) ? '' : a:1, empty(a:2) ? 0 : 1)
endfu

fun! <sid>CreateSignFiles(fname, force)
    if !empty(s:signs) && !empty(keys(s:signdict))
	if !empty(a:fname) && !isdirectory(a:fname) && (a:force || !filereadable(a:fname))
	    let filename=a:fname
	else
	    if filereadable(a:fname)
		call <sid>Output("File " . a:fname . " exists! Creating new file. Use '!' to override.", "WarningMsg")
	    endif
	    let filename=tempname()
	endif

	if bufloaded(filename) && bufwinnr(filename) > 0
	    exe bufwinnr(filename) . "wincmd w"
	else
	    exe ":sp" filename
	endif
	%d _

	call append('.', [ '" Source this file, to reload all signs',
		    \'" Signs that are defined for files which are currently not loaded',
		    \'" will not be restored!',
		    \'',
		    \'" Check for +sign Feature',
		    \'if !has("signs") | finish | endif ',
		    \'',
		    \'" Remove all previously placed signs',
		    \'sign unplace *',
		    \'',
		    \'" Undefine all previously defined signs' ,
		    \'redir => s:a | exe "sil sign list" | redir end',
		    \'let s:signlist=split(s:a, "\n")',
		    \"call map(s:signlist, '\"sign undefine \" . split(v:val, ''\\s\\+'')[1]')",
		    \'for sign in s:signlist | exe sign | endfor ', 
		    \'unlet s:signlist s:a',
		    \''])
	$
	call append('.',s:signs)
	for file in keys(s:signdict)
	    call append('$', s:signdict[file])
	endfor
	setf vim
	1
	d
	"setl nomodified
    else
	    call <sid>Output("No Signs Defined. Nothing to do", "WarningMsg")
    endif
endfun

" Restore:"{{{
let &cpo=s:cpo
unlet s:cpo"}}}
" vim: ts=4 sts=4 fdm=marker com+=l\:\"
