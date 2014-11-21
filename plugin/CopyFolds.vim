function CopyNonFolded()
let lnum=1
let buffer=[]
while lnum <= line("$")
    if (foldclosed(lnum) == -1)
        let buffer += getline(lnum, lnum)
        let lnum += 1
    else
        let buffer += [ foldtextresult(lnum) ]
        let lnum = foldclosedend(lnum) + 1
    endif
endwhile
top new
set bt=nofile
call append(".",buffer)
0d_
endfu
