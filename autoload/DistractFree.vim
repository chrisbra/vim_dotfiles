" DistractFree.vim - A DarkRoom/WriteRoom like plugin
" -------------------------------------------------------------
" Version:	   0.5
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Last Change: Wed, 14 Aug 2013 22:36:39 +0200
"
" Script: http://www.vim.org/scripts/script.php?script_id=4357
" Copyright:   (c) 2009 - 2013 by Christian Brabandt
"			   The VIM LICENSE applies to DistractFree.vim 
"			   (see |copyright|) except use "DistractFree.vim" 
"			   instead of "Vim".
"			   No warranty, express or implied.
"	 *** ***   Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts: 4357 5 :AutoInstall: DistractFree.vim
"
" Functions:
" (autoloaded) file

" Functions: "{{{1
" Output a warning message, if 'verbose' is set
fu! <sid>WarningMsg(text, force) "{{{2
	if empty(a:text)
		return
	endif
	let text = "DistractFree: ". a:text
	let v:errmsg = text
	if !&verbose && !a:force
		return
	endif
	echohl WarningMsg
	unsilent echomsg text
	echohl None
endfu

let s:distractfree_active = 0
fu! <sid>Init() " {{{2
    " The desired column width.  Defaults to 90%
    if !exists( "g:distractfree_width" )
        let g:distractfree_width = '90%'
    endif

    " The colorscheme to load
    if !exists( "g:distractfree_colorscheme" )
        let g:distractfree_colorscheme = ""
    endif

    " The font to use
    if !exists( "g:distractfree_font" )
        let g:distractfree_font = ""
    endif


    if exists("g:distractfree_nomap_keys")
        let s:distractfree_nomap_keys = g:distractfree_nomap_keys
    endif

	" Set those options to their values in distractfree mode, if you don't
	" want them to be set, set the option g:distractfree_keep_options to
	" include the option values
	"
    " The "scrolloff" value: how many lines should be kept visible above and below
    " the cursor at all times?  Defaults to 999 (which centers your cursor in the 
    " active window).
	let s:_def_opts = {'t_mr': '', 'scrolloff': get(g:, 'distractfree_scrolloff', 999),
				\ 'laststatus': 0, 'textwidth': winwidth(winnr()), 'number': 0,
				\ 'relativenumber': 0, 'linebreak': 1, 'wrap': 1, 'g:statusline': '%#Normal#',
				\ 'l:statusline': '%#Normal#', 'cursorline': 0, 'cursorcolumn': 0,
				\ 'ruler': 0, 'guioptions': '', 'fillchars':  'vert:|', 'showtabline': 0,
				\ 'showbreak': ''}

    " Given the desired column width, and minimum sidebar width, determine
    " the minimum window width necessary for splitting to make sense
    if match(g:distractfree_width, '%') > -1 && has('float')
        let s:minwidth  = float2nr(round(&columns *
				\ (matchstr(g:distractfree_width, '\d\+')+0.0)/100.0))
        let s:minheight = float2nr(round(&lines *
				\ (matchstr(g:distractfree_width, '\d\+')+0.0)/100.0))
    else
        " assume g:distractfree_width contains columns
        let s:minwidth = matchstr(g:distractfree_width, '\d\+')
        let s:minheight = s:minwidth/2
    endif
	if !exists("s:sessionfile")
		let s:sessionfile = tempname()
	endif
endfu

fu! <sid>LoadFile(cmd) " {{{2
	" Try to load a file. When the given file does not exists, return 0
	" on success return 1
	if empty(a:cmd)
		return
	endif
	let v:statusmsg = ""
	exe 'verbose sil ru ' . a:cmd
	if !empty(v:statusmsg)
		" file not found
		return 0
	else
		return 1
	endif
endfu

fu! <sid>SaveRestore(save) " {{{2
    if a:save
		let s:main_buffer = bufnr('')
		if exists("g:colors_name")
			let s:colors = g:colors_name
			let s:higroups = <sid>SaveHighlighting('User')
		endif
		if !empty(g:distractfree_font)
			let s:guifont = &guifont
			sil! let &guifont=g:distractfree_font
		endif

		let s:_opts = {}

		for opt in keys(s:_def_opts)
			if match(get(g:, 'distractfree_keep_options', ''), opt) > -1
				continue
			elseif exists("+". (opt=~ '^[glw]:' ? opt[2:] : opt))
				if (opt == 'g:statusline' && get(g:, 'loaded_airline', 0) && exists(":AirlineToggle") == 2)
					" Disable airline statusline
					:AirlineToggle
				endif
				exe 'let s:_opts["'.opt. '"] = &'. (opt =~ '^[glw]:' ? '' : 'l:'). opt
				exe 'let &'. (opt =~ '^[glw]:' ? '' : 'l:').opt. '="'. s:_def_opts[opt].'"'
			endif
		endfor
		" Try to load the specified colorscheme
		if exists("g:distractfree_colorscheme") && !empty(g:distractfree_colorscheme)
			let colors = "colors/". g:distractfree_colorscheme . (g:distractfree_colorscheme[-4:] == ".vim" ? "" : ".vim")
			if !(<sid>LoadFile(colors))
				call <sid>WarningMsg("Colorscheme ". g:distractfree_colorscheme. " not found!",0)
			endif
		endif
        " Set highlighting
        for hi in ['VertSplit', 'NonText', 'SignColumn']
            call <sid>ResetHi(hi)
        endfor
    else
		unlet! s:main_buffer
		unlet! g:colors_name
		if exists("s:colors")
			exe "colors" s:colors
			for item in s:higroups
				exe "sil!" item
			endfor
		endif
		if exists("s:guifont")
			let &guifont = s:guifont
		endif
		for [opt, val] in items(s:_opts)
			if (opt == 'g:statusline' && get(g:, 'loaded_airline', 0) && exists(":AirlineToggle") == 2)
				" Disable airline statusline
				:AirlineToggle
			endif
			exe 'let &'.(opt =~ '^[glw]:' ? '' : 'l:').opt. '="'. val.'"'
		endfor

"        let [ &l:t_mr, &l:so, &l:ls, &l:tw, &l:nu, &l:lbr, &l:wrap, &l:stl, &g:stl, &l:cul, &l:cuc, &l:go, &l:fcs, &l:ru ] = s:_a
"        if exists("+rnu")
"            let &l:rnu = s:_rnu
"        endif
    endif
endfu

fu! <sid>ResetHi(group) "{{{2
	if !exists("s:default_hi")
		redir => s:default_hi | sil! hi Normal | redir END
		let s:default_hi = substitute(s:default_hi, 'font=.*$', '', '')
		let s:default_hi = substitute(s:default_hi, '.*xxx\s*\(.*$\)', '\1', '')
		let s:default_hi = substitute(s:default_hi, '\w*fg=\S*', '', 'g')
		let s:default_hi = substitute(s:default_hi, '\(\w*\)bg=\(\S*\)', '\0 \1fg=\2', 'g')
	endif
	if s:default_hi == 'cleared'
		exe "sil syn clear" a:group
	else
		exe "sil hi" a:group s:default_hi
	endif
endfu

fu! <sid>NewWindow(cmd) "{{{2
    exe a:cmd
    sil! setlocal noma nocul nonu nornu buftype=nofile winfixwidth winfixheight nobuflisted bufhidden=wipe
    let &l:stl='%#Normal#'
    let s:bwipe = bufnr('%')
	augroup DistractFreeWindow
		au!
		au BufEnter <buffer> call <sid>BufEnterHidden()
		if exists("##QuitPre")
			au QuitPre <buffer> bw
		endif
	augroup END
    noa wincmd p
endfu

fu! <sid>BufEnterHidden() "{{{2
	let &l:stl = '%#Normal#'
	if !bufexists(s:main_buffer) ||
		\ !buflisted(s:main_buffer) ||
		\ !bufloaded(s:main_buffer) ||
		\ bufwinnr(s:main_buffer) == -1
		exe s:bwipe "bw!"
	else
		noa wincmd p
	endif
endfu

fu! <sid>MapKeys(enable) "{{{2
    if exists("s:distractfree_nomap_keys") && s:distractfree_nomap_keys
        return
    endif
	if !exists("s:mapped_keys")
		let s:mapped_keys = []
	endif
    let keys = {}
    " Order matters!
    let keys['n'] = ['<Up>', '<Down>', 'k', 'j']
    let keys['i'] = ['<Up>', '<Down>']
    if a:enable
        try
            call add(s:mapped_keys, maparg('<Up>', 'n', 0, 1))
            if !hasmapto('g<Up>', 'n')
                nnoremap <unique><buffer><silent> <Up> g<Up>
            endif
            call add(s:mapped_keys, maparg('<Down>', 'n', 0, 1))
            if !hasmapto('g<Down>', 'n')
                nnoremap  <unique><buffer><silent> <Down> g<Down>
            endif
            call add(s:mapped_keys, maparg('k', 'n', 0, 1))
            if !hasmapto('gk', 'n')
                nnoremap  <unique><buffer><silent> k gk
            endif
            call add(s:mapped_keys, maparg('j', 'n', 0, 1))
            if !hasmapto('gj', 'n')
                nnoremap  <unique><buffer><silent> j gj
            endif
            call add(s:mapped_keys, maparg('<Up>', 'i', 0, 1))
            if !hasmapto('<C-\><C-O><Up>', 'i')
                inoremap <unique><buffer><silent> <Up> <C-\><C-O><Up>
            endif
            call add(s:mapped_keys, maparg('<Down>', 'i', 0, 1))
            if !hasmapto('<C-\><C-O><Down>', 'i')
                inoremap <unique><buffer><silent> <Down> <C-\><C-O><Down>
            endif
        catch /E227:/
            " Noop: echo "Distractfree mappings already exist."
        catch /E225:/
            " Noop: echo "Distractfree global mappings already exist."
        endtry
    else
        " restore mappings keys, if they were mapped
        let index = 0
        for map in s:mapped_keys
            " key was not mapped
            if empty(map)
                let key = get(keys['n'] + keys['i'],index,0)
                if key != 0
                    exe "sil! nunmap <buffer>" key
                endif
            else
				let ounmap = (map.mode == 'nv')
                let cmd = ( ounmap ? '' : map.mode)
                let cmd .= (map.noremap ?  'nore' : ''). 'map '
                let cmd .= (map.silent ? '<silent>' : '')
                let cmd .= (map.buffer ? '<buffer>' : '')
                let cmd .= (map.expr ? '<expr>' : '')
                let cmd .= ' '
                let cmd .= map.lhs. ' '
                if map.sid && map.rhs =~# '<sid>'
                    let map.rhs = substitute(map.rhs, '\c<sid>', '<snr>'. map.sid. '_', '')
                endif
                let cmd .= map.rhs
                exe cmd
				if ounmap
					exe 'ounmap' map.lhs
				endif
            endif
            let index += 1
        endfor
        let s:mapped_keys = []
    endif
endfu

fu! <sid>SaveHighlighting(pattern) "{{{2
	" Save and Restore User1-User10 highlighting
    redir => a|exe "sil hi"|redir end
    let b = split(a[1:], "\n")
    call filter(b, 'v:val !~ ''\(links to\)\|cleared''')
    let i = 0
    while i < len(b)
		let b[i] = substitute(b[i], 'xxx', '', '')
		if i > 0 && b[i] =~ '^\s\+'
			let b[i-1] .= ' '. join(split(b[i]), " ")
			call remove(b, i)
		else
			let i+=1
		endif
    endw
	call map(b, '''hi ''. v:val')
    return filter(b, 'v:val=~a:pattern')
endfu

fu! <sid>SaveRestoreWindowSession(save) "{{{2
	if a:save
		let _so = &ssop
		let &ssop = 'blank,buffers,curdir,folds,help,unix,tabpages,winsize'
		exe ':mksession!' s:sessionfile
		let &ssop = _so
	else
		if exists("s:sessionfile") && filereadable(s:sessionfile)
			exe ":sil so" s:sessionfile
			"call delete(s:sessionfile)
		endif
	endif
endfu

fu! DistractFree#DistractFreeToggle() "{{{2
    call <sid>Init()
    if s:distractfree_active == 1
        " Close upper/lower/left/right split windows
		" ignore errors
		try
			exe s:bwipe. "bw"
			call <sid>SaveRestoreWindowSession(0)
		catch " catch all
			let s:distractfree_active = 0
			return
		finally 
			unlet! s:bwipe
			" Reset options
			call <sid>SaveRestore(0)
			" Reset mappings
			call <sid>MapKeys(0)
			" Reset closing autocommand
			if exists("#DistractFreeMain")
				augroup DistractFreeMain
					au!
				augroup END
				augroup! DistractFreeMain
			endif
			if exists("g:distractfree_hook") && get(g:distractfree_hook, 'stop', 0) != 0
				exe g:distractfree_hook['stop']
			endif
		endtry
    else
		call <sid>SaveRestoreWindowSession(1)
		try
			sil wincmd o
		catch
			" wincmd o does not work, probably because of other split window
			" which have not been saved yet
			call <sid>WarningMsg("Can't start DistractFree mode, other windows contain non-saved changes!", 1)
			return
		endtry
        call <sid>SaveRestore(1)
        let s:sidebar = (&columns - s:minwidth) / 2
        let s:lines = (&lines - s:minheight) / 2
        " Create the left sidebar
        call <sid>NewWindow("noa sil leftabove ".  s:sidebar. "vsplit new")
        " Create the right sidebar
        call <sid>NewWindow("noa sil rightbelow ". s:sidebar. "vsplit new")
        " Create the top sidebar
        call <sid>NewWindow("noa sil leftabove ".  s:lines.   "split new")
        " Create the bottom sidebar
        call <sid>NewWindow("noa sil rightbelow ". s:lines.   "split new")
        " Setup navigation over "display lines", not "logical lines" if
        " mappings for the navigation keys don't already exist.
        call <sid>MapKeys(1)

		" Set autocommand for closing the sidebar
		if exists("##QuitPre")
			augroup DistractFreeMain
				au!
				au QuitPre <buffer> :exe "noa sil! ". s:bwipe. "bw"
				au VimLeave * :call delete(s:sessionfile)
			augroup END
		endif

        if exists("g:distractfree_hook") && get(g:distractfree_hook, 'start', 0) != 0
            exe g:distractfree_hook['start']
        endif
		" exe "windo | if winnr() !=".winnr(). "|let &l:stl='%#Normal#'|endif"
    endif
    let s:distractfree_active = !s:distractfree_active
endfunction

fu! DistractFree#Active() "{{{2
	return s:distractfree_active
endfunction
" vim: ts=4 sts=4 fdm=marker com+=l\:\"
