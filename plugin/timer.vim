" A timer command, to time some commands taken from:
" http://vim.wikia.com/wiki/Time_your_Vim_commands
com! -count=0 -complete=command -nargs=+ Timer call s:Timer(<q-args>, <q-count>)
fun! s:Timer(cmd, count)
    let rel = has("reltime")
    let ct  = rel ? reltime() : localtime()
    let maxrep = (a:count > 0 ? a:count : 10)

    for i in range(maxrep)
	exec a:cmd
    endfor

    if rel
	let res = str2float(reltimestr(reltime(ct)))
    else
	let t=strftime("%s")
	let dt = t - ct
	let frac= (dt+0.0)/maxrep
    endif

    redraw!
    echohl MoreMsg
    echo printf("%*d rounds:\t%.02g sec", len(maxrep), maxrep,
	\ (rel ? res : dt+0.0))
    echo printf("%*d round :\t%.02g sec", len(maxrep), 1, 
	\ (rel ? res/maxrep : frac))
    echohl None
endfun
