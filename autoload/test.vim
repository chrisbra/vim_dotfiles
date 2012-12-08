fun! test#WarningMsg(msg)"{{{1 
	sleep 10s
        echohl WarningMsg 
        echomsg a:msg 
        echohl Normal 
        let v:errmsg = a:msg 
endfun "}}} 
