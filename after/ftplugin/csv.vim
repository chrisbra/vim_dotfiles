
fun! My_CSV_Average(col)
    let sum=0
    for item in a:col
	let sum+=item
    endfor
    return sum/len(a:col)
endfun

command! -buffer -nargs=? -range=% AvgCol :echo csv#EvalColumn(<q-args>,
    \ "My_CSV_Average", <line1>,<line2>)
