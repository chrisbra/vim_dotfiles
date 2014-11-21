" -------------------------------------------
" Last update: Mo 2007-04-16 23:19
" -------------------------------------------
" Commands for quoting URLs in emails
" Copyright (c) 2001-2004 Hugo Haas
" 2004-06-01 version
" I hereby put this code in the public domain.
" Documentation at: http://larve.net/people/hugo/2001/02/email-uri-refs/
" --------------------------------------------

" Insert a reference at the cursor position
function! InsertRef() abort
  let l:ref = input("Reference: ")
  call AskNumber()
  set paste
  if (col(".") == 1)
    execute "normal i[\<C-R>r]\<ESC>"
  else
    execute "normal a[\<C-R>r]\<ESC>"
  endif
  normal G
  " Search for signature string and go up 3 Lines (Signoff Setting in muttng)
  ?^-- $?-3
  execute "normal O  " . @r . ". " . ref . "\<ESC>`rf]"
  set nopaste
  let l:a = col(".")
  normal $
  let l:b = col(".")
  if ( l:a == l:b )
    startinsert!
  else
    normal `rf]l
    startinsert
  endif
endfunction

" Convert <http://example.com> into a reference
function! ConvertToRef() abort
  call AskNumber()
  set paste
  execute "normal cf>[\<C-R>r]\<ESC>G"
  " Search for signature string and go up 3 Lines (Signoff Setting in muttng)
  ?^-- $?-3
  execute "normal O  \<ESC>"
  execute "normal a\<C-R>r. \<ESC>px0f.2 x`r"
  set nopaste
endfunction

" Ask a reference number
function! AskNumber() abort
  if !exists("b:refNumber")
    let b:refNumber = 0
    call FindRefHiNumber()
  endif
  let b:refNumber = b:refNumber + 1
  let l:number = input("Reference number (" . b:refNumber . "): ")
  if ( l:number != "" )
    let b:refNumber = l:number
  endif
  let @r = b:refNumber
endfunction

" Find the highest number in the text
function! FindRefHiNumber() abort
  normal 1G
  /^$
  let l:body = line(".")
  let l:cur = l:body + 1
  let l:found = 0
  let @/="\\[[0-9]\\+\\]"
  while ( l:cur <= line("$") )
    if (match(getline(l:cur), @/) != -1)
      let l:found = 1
      break
    endif
    let l:cur = l:cur + 1
  endwhile
  if ( l:found == 0 )
    let b:refNumber = 0
    normal `r
    return
  endif
  " Find the highest number
  normal n
  let l:l = line(".")
  let l:c = col(".")
  while (1)
    if ( line(".") > l:body )
      normal f]mqF[ly`qf]
      if ((@0 + 0) > b:refNumber)
        let b:refNumber = @0
      endif
      normal n
    endif
    if ( (line(".") < l:body) || ((l:l == line(".")) && (l:c == col("."))) ) 
      break
    endif
  endwhile
  normal `r
endfunction

imap <F11> <ESC>mr:call InsertRef()<CR>
nmap <F12> F<mr:call ConvertToRef()<CR>
