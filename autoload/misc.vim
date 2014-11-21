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

fu! <sid>Interpolate(p, fro, to)
    return a:fro + a:p * (a:to - a:fro)
endfunction

function <sid>OnCursorMoved1()
    if !(&cul || &rnu)
	return
    endif
    let endLNr = line('$')
    if endLNr == 1
        let endLNr = 2
    endif
    let colors = [    [33, 196, 0],
                    \ [235, 235, 54],
                    \ [230, 28, 28]]
    let fg_colors = ['white', 'black', 'white']

    let p = (line('.') - 1) * 1.0 / (endLNr - 1)

    let fg_color_index = float2nr(p * len(fg_colors) - 0.001)
    let fg_color = fg_colors[fg_color_index]

    let color_index_from = float2nr(p * (len(colors) - 1) - 0.001)
    let color_index_to = color_index_from + 1
    let p2 = (p * (len(colors) - 1 )) - color_index_from

    let color_from = colors[color_index_from]
    let color_to = colors[color_index_to]

    let r = float2nr(<sid>Interpolate(p2, color_from[0], color_to[0]) )
    let g = float2nr(<sid>Interpolate(p2, color_from[1], color_to[1]) )
    let b = float2nr(<sid>Interpolate(p2, color_from[2], color_to[2]) )

    let c = printf('%02x%02x%02x', r, g, b)
    exe 'hi CursorLineNr guibg=#'.c.' guifg='.fg_color
endfunction

function misc#CursorLineNrAdjustment()
    if has("gui_running")
	aug CursorLineNr
	    au!
	    au CursorMoved * call <sid>OnCursorMoved1()
	augroup END
    else
	aug CursorLineNr
	    au GUIEnter * call misc#CursorLineNrAdjustment()
	aug END
    endif
endfu
