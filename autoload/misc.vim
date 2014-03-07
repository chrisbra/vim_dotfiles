fu! misc#List(command)
    if a:command == 'scriptnames'
	redir => a|exe "sil! scriptnames"|redir end
	let b = split(a, "\n")
	call map(b, 'matchstr(v:val, ''^\s*\d\+:\s\+\zs.*'')')
	call map(b, 'fnamemodify(v:val, '':p'')')
    elseif a:command == 'oldfiles'
	let b = v:oldfiles
    endif
    let loclist = []
    for file in b
	call add(loclist, {"filename": file,
	\ "lnum": 1})
    endfor
    call setloclist(0, loclist)
    lopen
endfu
