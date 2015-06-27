" When hitting Enter in the quickfix window
" use the last active window and not an arbitrary one

nnoremap <buffer> <CR> :call QfEnter()<CR>

function! QfEnter()
    let l:lnum = line('.')
    wincmd p
    if IsQuickfix()
      exe 'cc' l:lnum
    else
      exe 'll' l:lnum
    endif
endfunction

function! IsQuickfix()
  redir => buffers| exe "sil ls"| redir END

  let nr = bufnr('%')
  for buf in split(buffers, '\n')
    if match(buf, '^\s*'.nr) > -1
      if match(buf, '\cQuickfix') > -1
        return 1
      else
        return 0
      endif
    endif
  endfor
  return 0
endfunction
