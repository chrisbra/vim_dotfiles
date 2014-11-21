" File:         makemagic.vim
" Created:      2011 Apr 18
" Last Change:  2012 Dec 19
" Rev Days:     4
" Author:	Andy Wokula <anwoku@yahoo.de>
" License:	Vim License, see :h license
" Version:	0.1

"" Comments {{{

" nwo#magic#MakeMagic({pat})
"
"   remove embedded switches (\v, \m, \M and \V) from pattern {pat} by
"   converting {pat} into a purely magic pattern.  Return the converted
"   pattern.
"

" TODO
" - recognize [#-\\]], with spaces: [ #-\ \] ]
"   (collection ends at second ']')

" 2011 Nov 01	copied from asneeded\makemagic.vim
"		now asneeded\nwo\makemagic.vim (comments there!)
"}}}

" Init Folklore {{{
let s:cpo_save = &cpo
set cpo&vim
let g:nwo#magic#loaded = 1
"}}}

func! nwo#magic#MakeMagic(pat, ...) "{{{
    " {pat}	(string)
    " {a:1}	(boolean) initial magic mode (default follows the 'magic' option)

    if a:0>=1 ? a:1 : &magic
	let magic_mode = 'm'
	let bracket_is_magic = 1
    else
	let magic_mode = 'M'
	let bracket_is_magic = 0
    endif
    let result_pat = ''
    let endpos = strlen(a:pat)

    let spos = 0
    while spos >= 0 && spos < endpos
	let mc1 = a:pat[spos]
	let mc2 = a:pat[spos+1]

	let collection = 0
	if mc1 == '\'
	    if mc2 == '[' && !bracket_is_magic
		let collection = 1
		let spos += 1
	    elseif mc2 =~ '[vmMV]'
		let magic_mode = mc2
		let bracket_is_magic = mc2 =~# '[vm]'
		let spos += 2
	    elseif mc2 == '_'
		let mc3 = a:pat[spos+2]
		if mc3 == '['
		    let collection = 1
		endif
	    endif
	elseif mc1 == '[' && bracket_is_magic
	    let collection = 1
	endif

	if collection
	    let nextpos = matchend(a:pat, s:collection_skip_pat, spos)
	    if nextpos >= 0
		let magpart = strpart(a:pat, spos, nextpos-spos)
	    else
		let magpart = strpart(a:pat, spos)
	    endif
	else
	    let nextpos = match(a:pat, s:switchpat[magic_mode], spos)
	    if nextpos >= 0
		if nextpos == spos
		    continue " optional
		endif
		let part = strpart(a:pat, spos, nextpos-spos)
	    else
		let part = strpart(a:pat, spos)
	    endif
	    if magic_mode ==# 'v'
		let magpart = substitute(part, s:vmagic_items_pat, '\=s:ToggleVmagicBslash(submatch(0))', 'g')
	    elseif magic_mode ==# 'm'
		let magpart = part
	    elseif magic_mode ==# 'M'
		let s:rem_bslash_before = '.*[~'
		" the first two branches are only to eat the matches:
		let magpart = substitute(part, '\\%\[\|\\_\\\=.\|\\.\|[.*[~]', '\=s:ToggleBslash(submatch(0))', 'g')
	    elseif magic_mode ==# 'V'
		let s:rem_bslash_before = '^$.*[~'
		let magpart = substitute(part, '\\%\[\|\\_\\\=.\|\\.\|[\^$.*[~]', '\=s:ToggleBslash(submatch(0))', 'g')
	    endif
	endif

	let result_pat .= magpart
	let spos = nextpos
    endwhile

    return result_pat
endfunc "}}}

" s:variables {{{

" pattern to match very magic items:
let s:vmagic_items_pat = '\\.\|%\%([#$(UV[\^cdlouvx]\|''.\|[<>]\%(''.\|[clv]\)\)\|[&()+<=>?|]\|@\%([!=>]\|<[!=]\)\|{'

" not escaped - require an even number of '\' (zero or more) to the left:
let s:not_escaped  = '\%(\%(^\|[^\\]\)\%(\\\\\)*\)\@<='

" prohibit an unescaped match for '%' before what follows (used when trying
" to find '[', but not '%[', :h /\%[ )
let s:not_vmagic_opt_atoms = '\%(\%(^\|[^\\]\)\%(\\\\\)*%\)\@<!'

" not opt atoms - (used when trying to find '[', but not '\%[')
let s:not_opt_atoms = '\%(\%(^\|[^\\]\)\%(\\\\\)*\\%\)\@<!'

" match a switch (\V,\M,\m,\v) or the start of a collection:
let s:switchpat = {
    \ "v": s:not_escaped.'\%('.s:not_vmagic_opt_atoms.'\[\|\\[vmMV]\)',
    \ "m": s:not_escaped.'\%('.s:not_opt_atoms . '\[\|\\[vmMV]\)',
    \ "M": s:not_escaped.'\%(\\_\=\[\|\\[vmMV]\)',
    \ "V": s:not_escaped.'\%(\\_\=\[\|\\[vmMV]\)'}

" skip over a collection (starting at '[' (same for all magic modes) or
" starting at '\_[' (same for all modes))
let s:collection_skip_pat = '^\%(\\_\)\=\[\^\=]\=\%(\%(\\[\^\]\-\\bertn]\|\[:\w\+:]\|[^\]]\)\@>\)*]'

" }}}

" for magic modes 'V' and 'M'
func! s:ToggleBslash(patitem) "{{{
    " {patitem}	    magic char or '\'.char
    if a:patitem =~ '^.$'
	return '\'.a:patitem
    else
	let mchar = matchstr(a:patitem, '^\\\zs.')
	if stridx(s:rem_bslash_before, mchar) >= 0
	    return mchar
	else
	    return a:patitem
	endif
    endif
endfunc "}}}

func! s:ToggleVmagicBslash(patitem) "{{{
    " {patitem}	    magic char or '\'.char
    if a:patitem =~ '^\\'
	let mchar = a:patitem[1]
	if mchar =~ '[\^$.*[\]~\\[:alnum:]_]'
	    return a:patitem
	else
	    return mchar
	endif
    else
	return '\'.a:patitem
    endif
endfunc "}}}

" Modeline: {{{1
let &cpo = s:cpo_save
unlet s:cpo_save
" vim:ts=8:fdm=marker:
