" File:         explainpat.vim
" Created:      2011 Nov 02
" Last Change:  2012 Dec 19
" Rev Days:     3
" Author:	Andy Wokula <anwoku@yahoo.de>
" License:	Vim License, see :h license
" Version:	0.1

" :ExplainPattern [pattern]
"
"   parse the given Vim [pattern] (default: text in the Visual area) and
"   print a line of help (with color!) for each found pattern item.  Nested
"   items get extra indent.
"
"   A single-char [pattern] argument is used as register argument:
"	/	explain the last search pattern
"	*	explain pattern from the clipboard
"	a	explain pattern from register a
"

if exists("loaded_explainpat")
    finish
endif
let loaded_explainpat = 1

if v:version < 700
    echomsg "explainpat: you need at least Vim 7.0"
    finish
endif

com! -nargs=*  ExplainPattern  call explainpat#ExplainPattern(<q-args>)

" Modeline: {{{1
" vim:ts=8:fdm=marker:
