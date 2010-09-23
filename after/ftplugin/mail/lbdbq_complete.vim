" It seems that when you've started completion, vim chooses to ignore
" these mappings. That means we can simply 'invoke' the preferred
" completion method and then C-n and C-p will behave as they should while
" the menu is present
ino <C-n> <C-X><C-U>
ino <C-p> <C-X><C-U>


fun! LBDBCompleteFn(findstart, base)
    if a:findstart
	" locate the start of the word
	let line = getline('.')
	let start = col('.') - 1
	while start > 0 && line[start - 1] =~ '[^:,]'
	  let start -= 1
	endwhile
	while start < col('.') && line[start] =~ '[:, ]'
	    let start += 1
	endwhile
	return start
    else
	let res = []
	let query = substitute(a:base, '"', '', 'g')
	let query = substitute(query, '\s*<.*>\s*', '', 'g')
	for m in LbdbQuery(query)
	    call add(res, printf('"%s" <%s>', escape(m[0], '"'), m[1]))
	endfor
	return res
    endif
endfun

set completefunc=LBDBCompleteFn
