if exists(':terminal')
  " allow terminal buffer size to be very large
  let g:terminal_scrollback_buffer_size = 100000

  " map esc to exit to normal mode in terminal too
  tnoremap <Esc><Esc> <C-\><C-n>

  " Jump and Create splits easily
  tnoremap <A-h> <C-\><C-n><C-w>h
  tnoremap <A-j> <C-\><C-n><C-w>j
  tnoremap <A-k> <C-\><C-n><C-w>k
  tnoremap <A-l> <C-\><C-n><C-w>l
  tnoremap <A-c> <C-\><C-n><C-w>c
  nnoremap <A-h> <C-w>h
  nnoremap <A-j> <C-w>j
  nnoremap <A-k> <C-w>k
  nnoremap <A-l> <C-w>l
  nnoremap <A-c> <C-w>c
  tnoremap <A-d>t   <C-\><C-n>:vsp \| term://bash -l<CR>
  tnoremap <A-d>    <C-\><C-n>:vsp<CR>
  tnoremap <A-s-d>t <C-\><C-n>:sp \| term://bash -l<CR>
  tnoremap <A-s-d>  <C-\><C-n>:sp<CR>
  nnoremap <A-d>t   <ESC>:vsp \| term bash -l<CR>
  nnoremap <A-d>    <ESC>:vsp<CR>
  nnoremap <A-s-d>t <ESC>:sp \| term bash -l<CR>
  nnoremap <A-s-d>  <ESC>:sp<CR>

  " go into insert mode when entering the terminal
  au WinEnter term://* startinsert
endif
