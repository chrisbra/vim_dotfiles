"-------------------------------------------------------
" Vim Functions from 
" Christian Brabandt cb@256bit.org
"
" Last update: Fr 2012-07-06 20:07
" 
"-------------------------------------------------------

" DoubleQuote: inserts » or « instead of "
" Modified version of TexQuotes() by Benji Fisher <benji@e-math.AMS.org>
function! s:DoubleQuote()
    let l = line(".")
    let c = col(".")
    let restore_cursor = l . "G" . virtcol(".") . "|"
    normal! H
    let restore_cursor = "normal!" . line(".") . "Gzt" . restore_cursor
    execute restore_cursor

    " Find the appropriate open-quote and close-quote strings.
    let open = "»"
    let close = "«"
    let boundary = '\|'

    " Eventually return q; set it to the default value now.
    let q = open
    let pattern = 
                \ escape(open, '\~') .
                \ boundary .
                \ escape(close, '\~') .
                \ '\|^$\|"'

    while 1     " Look for preceding quote (open or close)
        call search(pattern, "bw")
        if strpart(getline('.'), col('.')-2, 2) != '\"'
            break
        endif
    endwhile

    " Now, test whether we actually found a _preceding_ quote; if so, is it
    " an open quote?
    if ( line(".") < l || line(".") == l && col(".") < c )
        if strpart(getline("."), col(".")-1) =~ '\V\^' . escape(open, '\')
            let q = close
        endif
    endif

    " Return to line l, column c:
    execute restore_cursor
    " Start with <Del> to remove the " put in by the :imap .
    return "\<Del>" . q
endfunction
" inoremap <buffer> <silent> _" "<Left><C-R>=<SID>DoubleQuote()<CR>


" SingleQuote: insert . or . instead of '
function! s:SingleQuote()
    let close = "."
    let open = "."
    let q = close
    if col(".") == 1 || strpart (getline("."), col(".")-2, 1) == ' '
        let q = open
    else
        let q = close
    endif
    return "\<Del>" . q
endfunction
"inoremap <buffer> <silent> _' "<Left><C-R>=<SID>SingleQuote()<CR>

" The Shell in a Box mode. 
" Requires zsh for "print -P $PS1" / replace if needed.
" Your prompt should end in > (and only contain one)

map __start :imap <C-V><C-M> <C-O>__cmd<C-V>\|imap <C-V><ESC> <C-V><ESC>__end<C-M>
noremap __end :iunmap <C-V><CR>\|iunmap <C-V><ESC><C-M>:"Vish ended.<C-M>
" For bash we substitue print -P $PS1 with echo 'vish> '
"noremap __cmd 0<ESC>f>ly$:r !<C-R>";print -P $PS1<C-M>A
"noremap __scmd :r !print -P $PS1<c-M>A
noremap __cmd 0<ESC>f>ly$:r !<C-R>";echo 'vish> '<C-M>A
noremap __scmd :r !echo 'vish> '<c-M>A
map ,sh __start__scmd


"-------------------------------------------------------
" AUTOCOMMANDS
"-------------------------------------------------------

" Update .*rc header
fun! UpdateRcHeader()
    let l:c=col(".")
    let l:l=line(".")
    if search("Last update:") != 0
        1,8s-\(Last update:\).*-\="Last update: ".strftime("%a %Y\-%m\-%d %R")-
    endif
    call cursor(l:l, l:c)
endfun

" Meine Autocommands
augroup configs
    autocmd!
     " Header von .vimrc und .bashrc automatisch updated
     autocmd BufWritePre *vimrc  :call UpdateRcHeader()
     autocmd BufWritePre *.vim  :call UpdateRcHeader()
     autocmd BufWritePre *bashrc :call UpdateRcHeader()
     autocmd BufWritePre */.mutt/* :call UpdateRcHeader()
     autocmd BufWritePre muttrc :call UpdateRcHeader()
     autocmd BufWritePre personal.vim :call UpdateRcHeader()
augroup END

"-------------------------------------------------------
" Tabbing
"-------------------------------------------------------
if version < 700
    finish
else
    function! MyTabLine()
      let s = ''
      for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
          let s .= '%#TabLineSel#'
        else
          let s .= '%#TabLine#'
        endif

    "    " set the tab page number (for mouse clicks)
        let s .= '%' . (i + 1) . 'T'. ' '. (i+1). ' '

        " the label is made by MyTabLabel()
        let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
      endfor

      " after the last tab fill with TabLineFill and reset tab page nr
      let s .= '%#TabLineFill#%T'

      " right-align the label to close the current tab page
      if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999Xclose'
      endif

      return s
    endfunction
endif
        
function! MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
return bufname(buflist[winnr - 1])
endfunction

function! CompileScript()
    " the name of the current file
    let fname = expand('%')

    " can't compile unless the file is saved
    if &modified
      echo printf('Please save %s before compiling', fname)
      return
    endif

    " decide how to execute the script:
    if &filetype == 'perl'
      execute printf('!perl %s', fname)

    elseif &filetype == 'ruby'
      execute printf('!ruby %s', fname)

    elseif &filetype == 'bash' || &filetype == 'sh'
      execute printf('!source %s', fname)

    else
      echo printf("Don't know how to compile filetype '%s'", &filetype)
    endif

endfunction

fu! ToggleFoldByCurrentSearchPattern()
  if !&foldenable
    set foldenable
    set foldmethod=expr
    set foldexpr=getline(v:lnum)!~@/
    :normal zM
    set foldmethod=manual
    echo "zR to open all folds; zo top open 1 fold; zc to close 1 fold"
  else
     set nofoldenable
  endif
endfu

" Insert the date in a certain format
function! InsertDate(format)
        if ! exists('*strftime')
                echoerr 'strftime() not defined'
                return -1
        endif
        let f = a:format
        if f == ""
                let f = '%c'
        endif
        exe "normal a\<C-R>=strftime(" . '"' . f . '"' .  ")\e"
endfunction

" :Date will insert the current date and time in your
" locale-dependent default format; or
" :Date %d %b %Y
"  will (today) insert
"  14 Nov 2006
"
 command! -nargs=0 DiffOrig
      \|let g:ShowDifferencesOriginalBuffer=bufnr('%')
      \|let DiffFileType=&ft
      \|execute 'bufdo setlocal nodiff foldcolumn=0'
      \|execute 'buffer' g:ShowDifferencesOriginalBuffer
      \|diffthis
      \|below vert new
      \|let g:ShowDifferencesScratchWindow=winnr()
      \|set buftype=nofile noswapfile bufhidden=wipe
      \|let &ft=DiffFileType
      \|unlet DiffFileType
      \|r #
      \|1d
      \|setlocal noma
      \|diffthis

 command! -nargs=0 NoDiffOrig
     \|let CurrentWinNr=winnr()
     \|execute g:ShowDifferencesScratchWindow 'wincmd w'
     \|setlocal nodiff foldcolumn=0
     \|close
     \|setlocal nodiff foldcolumn=0
     \|execute CurrentWinNr 'wincmd w'
     \|unlet CurrentWinNr

 func! ToggleDiffOrig()
     if exists("g:DiffOriginal")
         NoDiffOrig
         unlet g:DiffOriginal
     else
         DiffOrig
         let g:DiffOriginal=1
     endif
 endfunc

fu! DiffUnified()
        let diffexpr="diff -Nuar"
        let bname=bufname("")
        let origtemp=0
        " Case 1: File has a filename and is not modified
        if !&modified && !empty(bname)
            let tempfile=0
            let origFile=bname.".orig"
        else
        " Case 2: File has a filename and is modified
            if &modified && !empty(bname)
                if !filereadable(bname.".orig")
                    sp 
                    enew
                    r #
                    0d
                    let tempfile2=tempname()
                    exe ":sil w! " .tempfile2
                    wincmd q
                    let origtemp=1
                    wincmd p
                endif
                let origFile=bname.".orig"
        "       let bname=tempname()
        "       exe ":sil w! ".bname
        "       let tempfile=1
        " Case 2: File is new and is modified
            else
                if &modified
                    let origFile=bname.".orig"
                else
                    let origFile=""
                endif
            endif
            let bname=tempname()
            exe ":sil w! ".bname
            let tempfile=1
        endif
        try
            if !filereadable(origFile) 
                let origFile=input("With which file to diff?: ","","file")
            endif
            if !filereadable(bname)
                exe ":sil w! ".bname
            endif
            if empty(origFile)
                throw "nofile"
            endif
            exe "sil sp"
            exe "enew"
            set bt=nofile
            exe "sil r!".diffexpr." ".origFile." ".bname
            exe "0d_"
            exe "set ft=diff"
            " Clean up temporary files
            if  tempfile == 1
                exe "sil :!rm -f ". bname
                let tempfile=0
            endif
            if origtemp == 1
                exe "sil :!rm -f ". origFile
                let origtemp=0
            endif
        catch
        endtry
endf

command! MakePatch :call DiffUnified()

if has('user_commands')
        "command! -nargs=0 -bar WhatSyntax echomsg synIDattr(synID(line("."), col("."), 1), "name")
        "command! -nargs=0 WhatSyntax echomsg synIDattr(synID(line("."), col("."), 0), "name")
        command! -nargs=0 WhatSyntax call WhatSyntax()
endif

fu! WhatSyntax()
" show highlight groups under cursor with F10
    if exists(':for')
         echo "<" .
	    \ synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name')
	    \ .'> from:'
        let indent = ''
        for syn_id in synstack(line('.'), col('.'))
          echo indent.'<'.synIDattr(syn_id,"name").'>' 
          let indent .= ' '
        endfor
        unlet indent
    else
  " can't do for loop, at least display something
    echo "hi<" . 
	\ synIDattr(synID(line("."),col("."),1),"name")
        \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
        \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
    endif
endfu

" RS will execute a search within a visually selected area
" mark the area with v and type :RS pattern
command! -nargs=* -range RS exe 'normal /\%>' . (<line1> - 1) . 'l\%<'. (<line2> + 1) . 'l<args><CR>'

command! -nargs=* -bar Date call InsertDate(<q-args>)

" -----------------------------------
" Chose a random color scheme each time
" this file is sourced
" -----------------------------------
"let mycolors = split(globpath(&rtp,"**/colors/*.vim"),"\n")
"exe 'so ' . mycolors[localtime() % len(mycolors)]
"unlet mycolors
"
function! CleverTab() 
           if pumvisible() 
             return "\<C-N>" 
           endif 
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$' 
      return "\<Tab>" 
   elseif exists('&omnifunc') && &omnifunc != '' 
      return "\<C-X>\<C-O>" 
   else 
      return "\<Tab>" 
  endif 
endfunction 
"inoremap <Tab> <C-R>=CleverTab()<CR> 

"augroup TimeSpentEditing
"au!
"au VimEnter,BufRead,BufNew * call setbufvar(str2nr(expand('<abuf>')),
"                    \ 'tstart', reltime())
"augroup END

" vim ab Version 7.2 unterstüzt floating point.
"if version >= 702
"    fu! TimeSpentEditing()
"        let secs=round(1000*str2float(reltimestr(reltime(b:tstart))))/1000
"        let hours=floor(secs/3600)
"        let minutes=floor((secs-hours*3600)/60)
"        let seconds=secs-hours*3600-minutes*60
"        return printf("%0.0f:%02.0f:%06.3f",hours,minutes,seconds)
"        return 0
"    endf

"    com! TimeSpentEditing echo TimeSpentEditing()
"    map <silent> <leader>dt :TimeSpentEditing<CR>
"endif
"augroup TimeSpentEditing
"

function! GDigraph(arg)
    let old=@a
    redir @a
    silent digraphs
    redir end
    " let b=match(@a,a:arg)
    if (strlen(substitute(a:arg, ".", "x", "g")) == 1)
	let pat='..\s' . a:arg . '\s\+\d\+'
    else
	if ( a:arg !~ '\d\{2,}')
	    let pat = escape(a:arg, '.+~*\\') . '\s\+.'
	else
	    let pat = '..\s\+.\s\+' . str2nr(a:arg) . '\ze\%(\s\|\n\)'
	endif
    endif
	
    let i=1
    while (match(@a,pat,0,i) > 0)
	if (exists("b"))
	    let b.="\n".matchstr(@a,pat,0,i)
	else
	    let b=matchstr(@a,pat,0,i)
	endif
	let i+=1
    endwhile
    redraw
    let @a=old
    return printf("%s",b)
    "return 0
endfu

function! GDigraph1(arg)
    let old=@a
    redir @a
    silent digraphs
    redir end
    let list = split(@a, '..\s\+.\{1,2}\s\+\d\+\zs\(\s\+\|\n\)')
    let @a=old
    if (strlen(substitute(a:arg, ".", "x", "g")) == 1)
	let search=char2nr(a:arg)
    else
	let search=a:arg
    endif
	"let pat = '\<' . char2nr(a:arg) . '\>$'
    let pat = '\<' . char2nr(a:arg) . '\>$'
"    else
"	let pat = '\C\<' . escape(a:arg, '.+~*\\') . '\>'
"    endif

    let i=1
    let idx=match(list,pat)
    while ( idx >= 0)
        if (exists("b"))
            let b.="\n" . list[idx]
        else
            let b=list[idx]
        endif
        let i+=1
	let idx=match(list,pat,0,i)
    endwhile
    redraw
    return exists("b")?printf("%s",b):"nothing found!"
endfu

command! -nargs=1 GetDigraph :echo GDigraph1(<q-args>)

function! CompleteDigraph1(findstart,base)
    if a:findstart
	let line = getline('.')
	let start = col('.') - 1
	while start > 0 && line[start - 1] =~ '\a'
	    let start -= 1
	endwhile
	return start
    else
	" get this index file from
	" http://www.unicode.org/Public/UNIDATA/Index.txt
	let list=readfile(expand("~/.vim/Index.txt"))
	let i=1
	let idx=match(list,a:base)
	while ( idx >= 0)
	    let nr = str2nr(matchstr(list[idx], '\x\+$'),16)
	    call complete_add({'word':nr2char(nr), 'abbr':list[idx], 'icase':1, 'menu':printf("%s",nr2char(nr))})
	    let i+=1
	    let idx=match(list,a:base,0,i)
	    if complete_check()
		break
	    endif
	endwhile
	return {}
    endif
endfun


"set completefunc=CompleteDigraph1

function! Info(cmd)
      execute "new|r!info --subnodes --output - ". a:cmd
endfunction
com! -nargs=* Info call Info(<f-args>)

function! SpellLegend()
    for [l:group, l:explanation] in [
    \   ['SpellBad', 'word not recognized'],
    \   ['SpellCap', 'word not capitalized'],
    \   ['SpellRare', 'rare word'],
    \   ['SpellLocal', 'wrong spelling for selected region']
    \]
        echo ''
        echon l:group . "\t"
        execute 'echohl' l:group
        echon 'xxx'
        echohl None
        echon "\t" . l:explanation
    endfor
endfunction
command! -bar SpellLegend call SpellLegend()
