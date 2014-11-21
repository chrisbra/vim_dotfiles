" VIM function to insert block quotes like emacs blockquote.el
" Written by Andreas Ferber <af-vim@myipv6.de>
"
" Example:
" ,----[ title ]-
" | some text
" `----
"
" Without title:
" ,----
" | some text
" `----
"
" Usage:
"   Blockquote a range (default: current line)
"   :<range>Bq [title]
"   Blockquote a file
"   :Bqf {filename}
"   Blockquote a file, starting at line {start}
"   :Bqf {filename} {start}
"   Blockquote a file, starting at line {start} and ending at {end}
"   :Bqf {filename} {start} {end}
"   Remove a blockquote, starting at <range> (default: current line)
"   :<range>UBq

"
" Some helper functions
"

" Insert line before linenum
function! BqInsertLine(linenum, linestring)
    execute 'normal' . ":" . a:linenum . "insert\<CR>" . a:linestring .    "\<CR>.\<CR>"
endfunction

" Insert line after linenum
function! BqAppendLine(linenum, linestring)
    execute 'normal' . ":" . a:linenum . "append\<CR>" . a:linestring .    "\<CR>.\<CR>"
endfunction

" apply s/pat/rep/flags to linenum
function! BqSubstLine(linenum, pat, rep, flags)
    let l:thislineStr = getline(a:linenum)
    let l:thislineStr = substitute(l:thislineStr, a:pat, a:rep, a:flags)
    call setline(a:linenum, l:thislineStr)
endfunction

" delete a range of lines
function! BqDelete(startline, endline)
    execute 'normal:' . a:startline . ',' . a:endline . " delete\<CR>"
endfunction

"
" main functions
"

" blockquote a range, using the first argument (if given) as the title
" the cursor is positioned on the headline of the resulting blockquote
function! BlockQuote(...) range
    " insert "| " in front of each line
    let l:line = a:firstline
    while l:line <= a:lastline
        call BqSubstLine(l:line, '^.*$', '| &', "")
        let l:line = l:line + 1
    endwhile
    " insert end of blockquote
    call BqAppendLine(a:lastline, '`----')
    " and the headline
    if a:0 != 0 && a:1 != ""
        call BqInsertLine(a:firstline, ',----[ ' . a:1 . ' ]-')
    else
        call BqInsertLine(a:firstline, ',----')
    endif
endfunction

" insert a file into a blockquote, using the filename (without
" directory) as the blockquote title
" the blockquote is inserted after the current line, the cursor is
" positioned on the start of the headline
" Additional parameters can be used to give a startline or a range of
" lines which should be inserted from the file
function! BlockQuoteFile(filename, ...)
    " check if file is readable
    if !filereadable(a:filename)
        echoerr "Can't open file " . a:filename
        return
    endif
    " insert file
    execute "normal:read " . a:filename . "\<CR>"
    " save start and end of inserted text
    let l:bstart = line("'[")
    let l:bend = line("']")
    " length of the inserted text 
    let l:blen = l:bend - l:bstart + 1
    " check additional parameters
    if a:0 >= 1
        if a:0 >= 2 
            " two add. parameters, check plausibility
            if a:1 > a:2
                call BqDelete(l:bstart, l:bend)
                echoerr "Endline greater than Startline"
                return
            endif
            " first delete from end of wanted range to end of the
            " inserted text
            if a:2 < l:blen
                let l:delstart = l:bstart + a:2
                call BqDelete(l:delstart, l:bend)
                let l:bend = l:delstart - 1
                let l:blen = l:bend - l:bstart + 1
            endif
        endif
        if a:1 > l:blen
            call BqDelete(l:bstart, l:bend)
            echoerr "Startline after end of file"
            return
        endif
        " delete from start of inserted text up to start of wanted range
        let l:delend = l:bstart + a:1 - 2
        if l:delend >= l:bstart
            call BqDelete(l:bstart, l:delend)
            let l:bend = l:bend - a:1 + 1
            let l:blen = l:blen - a:1 + 1
        endif
    endif
    " now quote the inserted text
    let l:title = fnamemodify(a:filename, ":t")
    execute "normal:" . l:bstart . "," . l:bend . "call BlockQuote(l:title)\<CR>"
endfunction

" remove a blockquote starting at the start of the range
" removes always the whole blockquote, even if it exceeds the range
function! BlockUnQuote() range
    let l:thislineStr = getline(a:firstline)
    if match(l:thislineStr, ',----') != 0
        echoerr "Not on start of a blockquote"
        return
    endif
    let l:line = a:firstline
    call BqDelete(l:line, l:line)
    while getline(l:line) !~ '^`----'
        if l:line > line("$")
            echoerr "No end of blockquote found"
            return
        endif
        call BqSubstLine(l:line, '^| ', '', "")
        let l:line = l:line + 1
    endwhile
    call BqDelete(l:line, l:line)
endfunction

" and finally map the functions to Ex commands
command! -nargs=? -range Bq <line1>,<line2>call BlockQuote(<q-args>)
command! -nargs=+ -complete=file Bqf call BlockQuoteFile(<f-args>)
command! -nargs=0 -range UBq <line1>call BlockUnQuote()

" vi:ts=4 sw=4 expandtab
