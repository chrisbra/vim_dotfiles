" unicodePlugin : A completion plugin for Unicode glyphs
" Author: C.Brabandt <cb@256bit.org>
" Version: 0.14
" Copyright: (c) 2009 by Christian Brabandt
"            The VIM LICENSE applies to unicode.vim, and unicode.txt
"            (see |copyright|) except use "unicode" instead of "Vim".
"            No warranty, express or implied.
"  *** ***   Use At-Your-Own-Risk!   *** ***
"
" GetLatestVimScripts: 2822 14 :AutoInstall: unicode.vim

" ---------------------------------------------------------------------


if exists("g:unicode_URL")
    let s:unicode_URL=g:unicode_URL
else
    "let s:unicode_URL='http://www.unicode.org/Public/UNIDATA/Index.txt'
    let s:unicode_URL='http://www.unicode.org/Public/UNIDATA/UnicodeData.txt'
endif


let s:file=matchstr(s:unicode_URL, '[^/]*$')

let s:directory  = expand("<sfile>:p:h")."/unicode"
let s:UniFile    = s:directory . '/UnicodeData.txt'

fu! unicode#CompleteUnicode(findstart,base) "{{{1
  if !exists("s:numeric")
      let s:numeric=0
  endif
  if a:findstart
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\w\|+'
      let start -= 1
    endwhile
    if line[start] =~# 'U' && line[start+1] == '+' && col('.')-1 >=start+2
	let s:numeric=1
    else
	let s:numeric=0
    endif
    return start
  else
    if exists("g:showDigraphCode")
	let s:showDigraphCode=g:showDigraphCode
    else
	let s:showDigraphCode = 0
    endif
    if s:numeric
	let complete_list = filter(copy(s:UniDict),
		\ 'printf("%04X", v:val) =~? "^0*".a:base[2:]')
    else
	let complete_list = filter(copy(s:UniDict), 'v:key =~? a:base')
    endif
    for [key, value] in sort(items(complete_list), "<sid>CompareList")
    	"let key=matchstr(key, "^[^0-9 ]*")
	let dg_char=<sid>GetDigraphChars(value)
        if s:showDigraphCode
	    if !empty(dg_char)
		let fstring = printf("U+%04X %s (%s):'%s'", value, key, dg_char,
			    \ nr2char(value))
	    else
		let fstring=printf("U+%04X %s:%s", value, key, nr2char(value))
	    endif
	else
	    let fstring=printf("U+%04X %s:'%s'", value, key, nr2char(value))
	endif
	let istring = printf("U+%04X %s%s:'%s'", value, key,
			\ empty(dg_char) ? '' : '('.dg_char.')', nr2char(value))
    
	if s:unicode_complete_name
	    call complete_add({'word':key, 'abbr':fstring, 'info': istring})
	else
	    call complete_add({'word':nr2char(value), 'abbr':fstring, 'info': istring})
	endif
	if complete_check()
		break
	endif
    endfor
    	
    return {}
  endif
endfu

fu! unicode#CompleteDigraph() "{{{1
    let prevchar=getline('.')[col('.')-2]
    let prevchar1=getline('.')[col('.')-3]
    let dlist=<sid>GetDigraph()
    if prevchar !~ '\s' && !empty(prevchar)
	let filter1 =  '( v:val[0] == prevchar1 && v:val[1] == prevchar)'
	let filter2 = 'v:val[0] == prevchar || v:val[1] == prevchar'

	let dlist1 = filter(copy(dlist), filter1)
	if empty(dlist1)
	    let dlist = filter(dlist, filter2)
	    let col=col('.')-1
	else
	    let dlist = dlist1
	    let col=col('.')-2
	endif
	unlet dlist1
    else
       let col=col('.')
    endif
    let tlist=[]
    for args in dlist
	let t=matchlist(args, '^\(..\)\s<\?\(..\?\)>\?\s\+\(\d\+\)$')
	"echo args
	if !empty(t)
	    let format=printf("'%s' %s U+%04X",t[1], t[2], t[3])
	    call add(tlist, {'word':nr2char(t[3]), 'abbr':format,
		    \ 'info': printf("Abbrev\tGlyph\tCodepoint\n%s\t%s\tU+%04X",
		    \ t[1],t[2],t[3])})
       endif
    endfor
    call complete(col, tlist)
    return ''
endfu

fu! unicode#SwapCompletion() "{{{1
    if !exists('s:unicode_complete_name')
	let s:unicode_complete_name = 1
    endif
    if exists('g:unicode_complete_name')
	let s:unicode_complete_name = g:unicode_complete_name
    else
	let s:unicode_complete_name = !s:unicode_complete_name
    endif
    echo "Unicode Completion Names " .
	\ (s:unicode_complete_name ? 'ON':'OFF')
endfu

fu! unicode#Init(enable) "{{{1
    if !exists("s:unicode_complete_name")
		let s:unicode_complete_name = 0
    endif
    if a:enable
	let b:oldfunc=&l:cfu
	if (<sid>CheckDir())
	    let s:UniDict = <sid>UnicodeDict()
	    setl completefunc=unicode#CompleteUnicode
	    set completeopt+=menuone
	    inoremap <C-X><C-G> <C-R>=unicode#CompleteDigraph()<CR>
	    nnoremap <leader>un :call unicode#SwapCompletion()<CR>
	endif
    else
	if exists("b:oldfunc") && !empty(b:oldfunc)
	    let &l:cfu=b:oldfunc
	else
	    setl completefunc=
	endif
	unlet! s:UniDict
	if maparg("<leader>un", 'n')
	    nunmap <leader>un
	endif
	if maparg("<C-X><C-G>")
	    iunmap <C-X><C-G>
	endif
    endif
    echo "Unicode Completion " . (a:enable? 'ON' : 'OFF')
endfu

fu! unicode#GetUniChar() "{{{1
    if (<sid>CheckDir())
	if !exists("s:UniDict")
	    let s:UniDict=<sid>UnicodeDict()
	endif
	let msg = []

	" Get glyph at Cursor
	" need to use redir, cause we also want to capture combining chars
	redir => a | exe "silent norm! ga" | redir end 
	let a = substitute(a, '\n', '', 'g')
	" Special case: no character under cursor
        if a == 'NUL'
	    call add(msg, "No character under cursor!")
	    return
	endif
	let dlist = <sid>GetDigraph()
	" Split string, in case cursor was on a combining char
	for item in split(a, 'Octal \d\+\zs \?')

	    let glyph = substitute(item, '^<\(<\?[^>]*>\?\)>.*', '\1', '')
	    let dec   = substitute(item, '.*>\?> \+\(\d\+\),.*', '\1', '')
	    " Check for control char (has no name)
	    if dec <= 0x1F || ( dec >= 0x7F && dec <= 0x9F)
		call add(msg, printf("'%s' U+%04X <Control Char>", glyph, dec))
		" CJK Unigraphs start at U+4E00 and go until U+9FFF
	    elseif dec >= 0x4E00 && dec <= 0x9FFF
		call add(msg, printf("'%s' U+%04X CJK Ideograph", glyph, dec))
	    elseif dec >= 0xF0000 && dec <= 0xFFFFD
		call add(msg, printf("'%s' U+%04X character from Plane 15 for private use",
			\ glyph, dec))
	    elseif dec >= 0x100000 && dec <= 0x10FFFD
		call add(msg, printf("'%s' U+%04X character from Plane 16 for private use",
			\ glyph, dec))
	    else
		let dict = filter(copy(s:UniDict), 'v:val == dec')
		if empty(dict)
		" not found
		    call add(msg, "Character '%s' U+%04X not found", glyph, dec)
		endif
		let dig = filter(copy(dlist), 'v:val =~ ''\D''.dec.''$''')
		if !empty(dig)
		    let dchar = printf("(%s)", dig[0][0:1])
		else
		    let dchar = ''
		endif
		call add(msg, printf("'%s' U+%04X %s %s", glyph, values(dict)[0],
		    \ keys(dict)[0], dchar))
	    endif
	endfor
	call <sid>OutputMessage(msg)
    else
	call <sid>WarningMsg(printf("Can't determine char under cursor, %s not found", s:UniFile))
    endif
endfun

fu! unicode#OutputDigraphs(match, bang) "{{{1
	let screenwidth = 0
	let digit = a:match + 0
	for dig in sort(<sid>GetDigraph(), '<sid>CompareDigraphs')
		" display digraphs that match value
		if dig !~# a:match && digit == 0
			continue
		endif
		let item = matchlist(dig, '\(..\)\s\(\%(\s\s\)\|.\{,4\}\)\s\+\(\d\+\)$')

		" if digit matches, we only want to display digraphs matching the
		" decimal values
		if digit > 0 && digit !~ item[3]
			continue
		endif

		let screenwidth += strdisplaywidth(dig) + 2

		" if the output is too wide, echo an output
		if screenwidth > &columns || !empty(a:bang)
			let screenwidth = 0
			echon "\n"
		endif

		echohl Title
		echon item[2]
		echohl Normal
		echon " ". item[1]. " ". item[3] . " "
	endfor
endfu

fu! <sid>GetDigraphChars(code) "{{{1
    let dlist = <sid>GetDigraph()
    let ddict = {}
    for digraph in dlist
		let key=matchstr(digraph, '\d\+$')+0
		let val=split(digraph)
		let ddict[key] = val[0]
    endfor
    return get(ddict, a:code, '')
endfu

fu! <sid>UnicodeDict() "{{{1
    let dict={}
    let list=readfile(s:UniFile)
    for glyph in list
	let val          = split(glyph, ";")
	let Name         = val[1]
        let dict[Name]   = str2nr(val[0],16)
    endfor
    return dict
endfu

fu! <sid>CheckUniFile(force) "{{{1
    if (!filereadable(s:UniFile) || (getfsize(s:UniFile) == 0)) || a:force
	call s:WarningMsg("File " . s:UniFile . " does not exist or is zero.")
	call s:WarningMsg("Let's see, if we can download it.")
	call s:WarningMsg("If this doesn't work, you should download ")
	call s:WarningMsg(s:unicode_URL . " and save it as " . s:UniFile)
	sleep 10
	if exists(":Nread")
	    sp +enew
	    " Use the default download method. You can specify a different one,
	    " using :let g:netrw_http_cmd="wget"
	    exe ":lcd " . s:directory
	    exe "0Nread " . s:unicode_URL
	    $d _
	    exe ":w!" . s:UniFile
	    if getfsize(s:UniFile)==0
		call s:WarningMsg("Error fetching Unicode File from " . s:unicode_URL)
		return 0
	    endif
	    bw
	else
	    call s:WarningMsg("Please download " . s:unicode_URL)
	    call s:WarningMsg("and save it as " . s:UniFile)
	    call s:WarningMsg("Quitting")
	    return 0
	endif
    endif
    return 1
endfu

fu! <sid>CheckDir() "{{{1
    try
	if (!isdirectory(s:directory))
	    call mkdir(s:directory)
	endif
    catch
	call s:WarningMsg("Error creating Directory: " . s:directory)
	return 0
    endtry
    return <sid>CheckUniFile(0)
endfu

fu! <sid>GetDigraph() "{{{1
	if exists("s:dlist")
		return s:dlist
	else
		redir => digraphs
			silent digraphs
		redir END
		let s:dlist=[]
		let s:dlist=map(split(substitute(digraphs, "\n", ' ', 'g'), '..\s<\?.\{1,2\}>\?\s\+\d\{1,5\}\zs'), 'substitute(v:val, "^\\s\\+", "", "")')
		" special case: digraph 57344: starts with 2 spaces
		"return filter(dlist, 'v:val =~ "57344$"')
		let idx=match(s:dlist, '57344$')
		let s:dlist[idx]='   '.s:dlist[idx]

		return s:dlist
	endif
endfu

fu! <sid>CompareList(l1, l2) "{{{1
    return a:l1[1] == a:l2[1] ? 0 : a:l1[1] > a:l2[1] ? 1 : -1
endfu

fu! <sid>CompareDigraphs(d1, d2) "{{{1
	let d1=matchstr(a:d1, '\d\+$')+0
	let d2=matchstr(a:d2, '\d\+$')+0
	if d1 == d2
		return 0
	elseif d1 > d2
		return 1
	else
		return -1
	endif
endfu

fu! <sid>OutputMessage(msg) " {{{1
    redraw
    echohl Title
    if type(a:msg) == type([])
	for item in a:msg
	    echom item
	endfor
    elseif type(a:msg) == type("")
	" string
	echom a:msg
    endif
    echohl Normal
endfu

fu! <sid>WarningMsg(msg) "{{{1
    echohl WarningMsg
    let msg = "UnicodePlugin: " . a:msg
    if exists(":unsilent") == 2
	unsilent echomsg msg
    else
	echomsg msg
    endif
    echohl Normal
endfun

" Modeline "{{{1
" vim: ts=4 sts=4 fdm=marker com+=l\:\" fdl=0
