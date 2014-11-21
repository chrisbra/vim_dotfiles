" DistractFree.vim - A DarkRoom/WriteRoom like plugin
" -------------------------------------------------------------
" Version:	   0.5
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Last Change: Wed, 14 Aug 2013 22:36:39 +0200
"
" Script: http://www.vim.org/scripts/script.php?script_id=4357
" Copyright:   (c) 2009 - 2014 by Christian Brabandt
"			   The VIM LICENSE applies to DistractFree.vim 
"			   (see |copyright|) except use "DistractFree.vim" 
"			   instead of "Vim".
"			   No warranty, express or implied.
"	 *** ***   Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts: 4357 5 :AutoInstall: DistractFree.vim
"
" Functions:
" (autoloaded) file
let s:distractfree_active = 0

" Functions: "{{{1
" Output a warning message, if 'verbose' is set
fu! <sid>WarningMsg(text, force) "{{{2
	let text = "[DistractFree:]". a:text
	let v:errmsg = text
	if !&verbose && !a:force
		return
	endif
	echohl WarningMsg
	unsilent echomsg text
	echohl None
endfu

fu! <sid>Init() " {{{2
    " The desired column width. Defaults to 75%
	let g:distractfree_width       = get(g:, 'distractfree_width', '75%')
    " The desired height  Defaults to 80%
	let g:distractfree_height      = get(g:, 'distractfree_height', '80%')

    " The colorscheme to load
	let g:distractfree_colorscheme = get(g:, 'distractfree_colorscheme', '')

    " The font to use
	let g:distractfree_font        = get(g:, 'distractfee_font', '')

	" Set those options to their values in distractfree mode, if you don't
	" want them to be set, set the option g:distractfree_keep_options to
	" include the option values
	"
    " The "scrolloff" value: how many lines should be kept visible above and below
    " the cursor at all times?  Defaults to 999 (which centers your cursor in the 
    " active window).
	let s:_def_opts = {'t_mr': '', 'scrolloff': get(g:, 'distractfree_scrolloff', 999),
				\ 'laststatus': 0, 'textwidth': 'winwidth(winnr())', 'number': 0,
				\ 'relativenumber': 0, 'linebreak': 1, 'wrap': 1, 'g:statusline': '%#Normal#',
				\ 'l:statusline': '%#Normal#', 'cursorline': 0, 'cursorcolumn': 0,
				\ 'ruler': 0, 'guioptions': '', 'fillchars':  'vert: ', 'showtabline': 0,
				\ 'showbreak': '', 'foldenable': 0, 'tabline': '', 'guitablabel': '', 'lazyredraw': 1,
				\ 'breakindent': 1}

    " Given the desired column width, and minimum sidebar width, determine
    " the minimum window width necessary for splitting to make sense
    if match(g:distractfree_width, '%') > -1 && has('float')
        let s:minwidth  = float2nr(round(&columns *
				\ (matchstr(g:distractfree_width, '\d\+')+0.0)/100.0))
	else
        let s:minwidth = matchstr(g:distractfree_width, '\d\+')
	endif

    if match(g:distractfree_height, '%') > -1 && has('float')
        let s:minheight = float2nr(round(&lines *
				\ (matchstr(g:distractfree_height, '\d\+')+0.0)/100.0))
    else
        " assume g:distractfree_width contains columns
        let s:minheight = matchstr(g:distractfree_height, '\d\+')
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
			let s:higroups = <sid>SaveHighlighting('User\|NonText')
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
				if (opt == 'g:statusline')
					" Disable custom statusline
					call <sid>ResetStl(1)
				endif
				exe 'let s:_opts["'.opt. '"] = &'. (opt =~ '^[glw]:' ? '' : 'l:'). opt
				if (opt == 'textwidth')
					" needs to be evaluated
					exe 'let &l:'.opt. '='. s:_def_opts[opt]
				else
					exe 'let &'. (opt =~ '^[glw]:' ? '' : 'l:').opt. '="'. s:_def_opts[opt].'"'
				endif
			endif
		endfor
		" Try to load the specified colorscheme
		if exists("g:distractfree_colorscheme") && !empty(g:distractfree_colorscheme)
			" prevent CSApprox from kicking in...
			exe "noa colorscheme" fnamemodify(g:distractfree_colorscheme, ':r')
		endif
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
			" Check, that the option is actually supported
			if !exists('+'.(opt =~ '^[glw]:' ? 'opt[2:]' : opt))
				continue " option not supported, skip
			endif
			exe 'let &'.(opt =~ '^[glw]:' ? '' : 'l:').opt. '="'. val.'"'
			if (opt == 'g:statusline')
				" Enable airline statusline
				" Make sure airline autocommand does not exists (else it might disable Airline again)
				if exists('#airline')
					exe "aug airline"| exe "au!"|exe "aug end"|exe "aug! airline"
				endif
				call <sid>ResetStl(0)
			endif
		endfor
    endif
endfu
fu! <sid>NewWindow(cmd) "{{{2
	"call <sid>WarningMsg(printf("%s noa sil %s",(exists(":noswapfile") ? ':noswapfile': ''),a:cmd),0)
	" needs some 7.4.1XX patch
	exe printf("%s noa sil %s",(exists(":noswapfile") ? ':noswapfile': ''),a:cmd)
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
	" Disallow remapping of keys
	if get(g:, 'distractfree_nomap_keys', 0)
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
			aug DistractFree_SessionLoad
				au!
				au SwapExists * call <sid>WarningMsg("Found swapfile ".v:swapname.". Opening [RO]!",1)|let v:swapchoice='o'
			aug end
			exe ":sil so" s:sessionfile
			aug DistractFree_SessionLoad
				au!
			aug end
			aug! DistractFree_SessionLoad
			"call delete(s:sessionfile)
		endif
	endif
endfu
fu! <sid>ResetStl(reset) "{{{2
	if a:reset
		" disable custom statusline
		if exists("#airline") && exists(":AirlineToggle") == 2
			:AirlineToggle
		endif
		let s:_stl = &l:stl
		let cur_win = winnr()
		windo let &l:stl='%#Normal#'
		exe "noa" cur_win "wincmd w"
	else
		if exists("s:_stl") && !exists(":AirlineToggle")
			let &l:stl=s:_stl
		endif
		if !exists("#airline") && exists(":AirlineToggle") == 2
			" enable airline
			:AirlineToggle
		endif
		if exists(":AirlineRefresh") == 2
			" force refreshing the highlighting groups (might be off
			" because of loading a different color scheme).
			AirlineRefresh
		endif
	endif
endfu
fu! DistractFree#DistractFreeToggle() "{{{2
    call <sid>Init()
    if s:distractfree_active
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
			let s:distractfree_active=0
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
			if exists("g:distractfree_hook") && has_key(g:distractfree_hook, 'stop') && !empty(g:distractfree_hook.stop)
				exe g:distractfree_hook['stop']
			endif
			if exists("#airline")
			" Make sure, statusline is updated immediately
				doauto <nomodeline> airline VimEnter
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
		" minus two for the window border
        let s:sidebar = ((&columns-2) - s:minwidth) / 2
        let s:lines = ((&lines-2) - s:minheight) / 2
        " Create the left sidebar
        call <sid>NewWindow("leftabove vert ".  (s:sidebar+s:sidebar/2). "split new")
        " Create the right sidebar
		" adjust sidebar widht (left width should be wider than right width)
        call <sid>NewWindow("rightbelow vert ". (s:sidebar-s:sidebar/2). "split new")
        " Create the top sidebar
        call <sid>NewWindow("leftabove ".  s:lines.   "split new")
        " Create the bottom sidebar
        call <sid>NewWindow("rightbelow ". s:lines.   "split new")
        call <sid>SaveRestore(1)
        " Setup navigation over "display lines", not "logical lines" if
        " mappings for the navigation keys don't already exist.
        call <sid>MapKeys(1)

		" Set autocommand for closing the sidebar
		aug DistractFreeMain
			au!
			if exists("##QuitPre")
				au QuitPre <buffer> :exe "noa sil! ". s:bwipe. "bw"
			endif
			au VimLeave * :call delete(s:sessionfile)
			if get(g:, 'distractfree_enable_normalmode_stl',0)
				au InsertEnter <buffer> call <sid>ResetStl(1)
				au InsertLeave <buffer> call <sid>ResetStl(0)
			endif
		aug END
		if get(g:, 'distractfree_enable_normalmode_stl',0)
			call <sid>ResetStl(0)
		endif

        if exists("g:distractfree_hook") && has_key(g:distractfree_hook, 'start') && !empty(g:distractfree_hook.start)
            exe g:distractfree_hook['start']
        endif
		" exe "windo | if winnr() !=".winnr(). "|let &l:stl='%#Normal#'|endif"
		let s:distractfree_active=1
    endif
endfunction

fu! DistractFree#Active() "{{{2
	return s:distractfree_active
endfunction
" vim: ts=4 sts=4 fdm=marker com+=l\:\"
