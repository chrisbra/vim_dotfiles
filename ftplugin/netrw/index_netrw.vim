" Commands and Mappings: "{{{1

com! -buffer IndexList :call <sid>DoIndex()

nmap <buffer> <silent> <f5> :IndexList<cr>

" Plugin Folkore "{{{1
if exists("g:loaded_netrwindex") || &cp
 finish
endif
let g:loaded_netrwindex = 1
let s:keepcpo          = &cpo
set cpo&vim

" Functions {{{1
fu! <sid>IndexEntries() "{{{2
    call <sid>SaveRestore(1)
    let s:filedic={}
    :1
    let s:first=search('.\?\V./', 'cnW')
    let cline=s:first
    while cline <= line('$')
	let content = getline(cline)
	let s:filedic[(cline - s:first + 1)] = content
	call setline(cline, content . ' ['. (cline - s:first +1) .']')
	let cline+=1
    endw
    call <sid>SaveRestore(0)
endfu

fu! <sid>HighlightIndex() "{{{2
    if exists("s:index_hl")
	sil! call matchdelete(s:index_hl)
    endif
    let s:index_hl = matchadd('WildMenu', '\%>' . (s:first-1) . 'l\[\d\+\]$')
endfu


fu! <sid>DoIndex() "{{{2
    if exists("s:filedic")
	call <sid>ClearIndex()
	unlet s:filedic
    endif
    call <sid>IndexEntries()
    call <sid>HighlightIndex()
    redraw!
    call <sid>JumpToIndex()
    call <sid>ClearIndex()
    unlet s:filedic
endfu

fu! <sid>ClearIndex() "{{{2
    call <sid>SaveRestore(1)
    exe 'silent! ' . s:first . ',$s/ \[\d\+\]$//g'
    call <sid>SaveRestore(0)
endfu

fu! <sid>SaveRestore(save) "{{{2
    if a:save
	let s:view=winsaveview()
	setl modifiable noro
    else
	setl nomodifiable nomod ro
	call winrestview(s:view)
    endif
endfu

fu! <sid>JumpToIndex() "{{{2
    call <sid>SaveRestore(1)
    let tag=input("Which tag to jump to: ")
    if !empty(tag) && !empty(get(s:filedic, tag, ''))
	call search('\V' . s:filedic[tag] . ' [' . tag . ']','cW')
	silent! s/ \[\d\+\]$//g
	setl nomodifiable nomod ro
	exe "norm ^\<cr>"
	redraw!
    else
	echomsg "Tag " . tag . " does not exist, aborting..."
    endif
    call <sid>SaveRestore(1)
endfu

" Commands and Mappings: "{{{1
"com! -buffer IndexList :call <sid>DoIndex()

"nmap <buffer> <silent> <f5> :IndexList<cr>

" Restoration And Modelines: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo

" Modeline {{{1
" vim: fdm=marker sw=2 sts=2 ts=8 fdl=0
