" This is from the VimTips Wiki:
" http://vim.wikia.com/wiki/VimTip1141
" with slight improvements for zero-width patterns
" command PP: print lines like :p or :# but with with current search pattern highlighted
command! -nargs=? -range -bar PP :call <sid>PrintWithSearchHighlighted(<line1>,<line2>,<q-args>)

function! <sid>PrintWithSearchHighlighted(line1,line2,arg) "{{{1
    let line = a:line1
    while line <= a:line2
	echo ""
	if a:arg =~ "#"
	    call <sid>EchoHl('LineNr', printf("%*d ", strlen(line('$')), line))
	endif
	let l = getline(line)
	let index = 0
	let cnt = 0
	while 1
	    let b = match(l, @/, index, cnt)
	    if b == -1
		call <sid>EchoHl('None', strpart(l,index))
		break
	    endif
	    let e = matchend(l, @/, index, cnt)
	    if e == b
		let e += 1
	    endif

	    call <sid>EchoHl('None', strpart(l, index, b-index))
	    call <sid>EchoHl('Search', strpart(l, b, e-b))
	    let index = e
	endw
	let line += 1
    endw
endfu

fu! <sid>EchoHl(hl, msg) "{{{1
    exe "echohl" a:hl
    echon a:msg
    echohl None
endfu
