" Plugin Settings:

if v:version >= 700
    " Minibuffexplorer: is not needed, as vim 7 provides tabbing
    " therefore diabling it:
    let loaded_minibufexplorer=1

    " Disbale vimspell (was needed for spellchecking in versions < 7)
    let loaded_vimspell=1
    
    " Enable autoinstalling the newest Plugins using GetLatextVimScripts
    let g:GetLatestVimScripts_allowautoinstall=1
else
    " Minibufferexplorer:
    " see: http://www.vim.org/scripts/script.php?script_id=159
    "
    " Used to display the several different files in a small top windows
    " like tabbing in firefox
    " First enable mapping Control+Vim Direction keys [hkjl]
    let g:miniBufExplMapWindowNavVim = 1
    " Now enable mapping of Control + Arrow Keys to window 
    let g:miniBufExplMapWindowNavArrows = 1
    " Finally enable Mapping of Ctrl+TAB/Ctrl+Shift-TAB for cycling between
    " the files
    let g:miniBufExplMapCTabSwitchBufs = 1
    " There is a bug in vim, to not always show up with syntax highlighting
    " together with the minibufexpl Script. This can be circumvented by:
    let g:miniBufExplForceSyntaxEnable = 1
    " The following Plugins need a vim version > 700
    " NERD Commenter 
    let loaded_nerd_comments = 1
    " genutils 
    let loaded_genutils = 1
    " lookupfile
    let g:loaded_lookupfile = 1
    " undo_tags
    let loaded_undo_tag=1
    " yankring
    let loaded_yankring = 30
    " vcscommand
    let loaded_VCSCommand = 1
endif

" 2html setting:
let html_whole_filler=1

" Make CSApprox shut up
let g:CSApprox_verbose_level=0

" CSV:
"let g:csv_comment = '#'
"let g:csv_hiHeader="DiffAdd"
"let g:csv_disable_fdt=1
"let g:csv_autocmd_arrange = 1
"aug CSV_Editing
"    au!
"    au BufRead,BufWritePost *.csv :%ArrangeColumn
"    au BufWritePre *.csv :%UnArrangeColumn
"aug end

" ChangesPlugin:
let g:changes_autocmd=1
let g:changes_verbose=0
let g:changes_vcs_check=1
"let g:changes_diff_preview=1

" CheckAttach:
"let g:checkattach_filebrowser = 'range'

" SudoEdit:
"let g:sudoDebug=1

" Colorizer Plugin:
let g:colorizer_auto_filetype="html,css"
"let g:colorizer_taskwarrior = 0
let g:colorizer_debug = 1
"let g:colorizer_only_unfolded = 1
"let g:colorizer_skip_comments = 1
let g:colorizer_colornames = 1
let g:colorizer_auto_map = 1
"let g:colorizer_auto_color = 1
"let g:colorizer_syntax=1

" NrwwRgn:
let b:nrrw_aucmd_close= "unlet! g:nrrw_custom_options"

" DynamicSigns:
"let g:Signs_Scrollbar = 1
let g:Signs_Bookmarks = 1
let g:SignsMixedIndentation = 1
"let g:Signs_Diff = 1
let g:Signs_QFList = 0
"let g:Signs_Diff = 1
"let g:Signs_Alternate = 1

" ft_improved
let g:ft_improved_multichars = 1
let g:ft_improved_ignorecase = 1
let g:ft_improved_nohighlight = 0

" DistractFree:
let g:distractfree_colorscheme = "darkroom"

" Replay:
let g:replay_record = 1

" Powerline:
" disabled
let g:Powerline_loaded = 1

" Airline:
" enable smart tabline
let g:airline#extensions#tabline#enabled = 1
" enable/disable detection of whitespace errors. >
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnamemod = ':t:.'
if &encoding == "utf-8"
    let g:airline_symbols = {}
    " unicode symbols
    "let g:airline_left_sep = '»'
    let g:airline_left_sep = '▶'
    "let g:airline_right_sep = '«'
    let g:airline_right_sep = '◀'
    "let g:airline_symbols.linenr = '␊'
    "let g:airline_symbols.linenr = '␤'
    let g:airline_symbols.linenr = '¶'
    let g:airline_symbols.branch = '⎇'
    "let g:airline_symbols.paste = 'ρ'
    let g:airline_symbols.paste = 'Þ'
    "let g:airline_symbols.paste = '∥'
    let g:airline_symbols.whitespace = 'Ξ'
    let g:airline_symbols.readonly = 'RO'
endif

" Neocomplcache:
let g:neocomplcache_enable_at_startup = 1
" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
"inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function()
"  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
"endfunction
" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
"inoremap <expr><C-y>  neocomplcache#close_popup()
"inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" Solarized Colorscheme:
"let g:solarized_termcolors=256
"colors solarized

" Unite: {{{
"call unite#filters#matcher_default#use(['matcher_fuzzy'])
let g:unite_data_directory='~/.vim/.cache/unite'
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable=1
let g:unite_source_file_rec_max_cache_files=3000
" let g:unite_split_rule="botright"

if executable('ag')
    let g:unite_source_grep_command='ag'
    let g:unite_source_grep_default_opts='--nocolor --nogroup --hidden'
    let g:unite_source_grep_recursive_opt=''
elseif executable('ack')
    let g:unite_source_grep_command='ack'
    let g:unite_source_grep_default_opts='--no-heading --no-color -a'
    let g:unite_source_grep_recursive_opt=''
endif

function! s:unite_settings()
nmap <buffer> Q <plug>(unite_exit)
nmap <buffer> <esc> <plug>(unite_exit)
imap <buffer> <esc> <plug>(unite_exit)
imap <buffer> <C-c> <plug>(unite_exit)
imap <buffer> jj <plug>(unite_insert_leave)
imap <buffer> <C-w> <plug>(unite_delete_backward_path)
"imap <buffer> <leader> <esc><leader>
call s:unite_tabs_and_windows()
endfunction
autocmd FileType unite call s:unite_settings()

nnoremap <silent> <space><space> :<C-u>Unite -buffer-name=files buffer file_mru bookmark file_rec/async<cr>
nnoremap <silent> <space>y :<C-u>Unite -buffer-name=yanks history/yank<cr>
nnoremap <silent> <space>l :<C-u>Unite -buffer-name=line line<cr>
nnoremap <silent> <space>/ :<C-u>Unite -buffer-name=search grep:.<cr>'])

function! s:unite_tabs_and_windows()
    nmap <buffer> <C-h> <C-w>h
    nmap <buffer> <C-j> <C-w>j
    nmap <buffer> <C-k> <C-w>k
    nmap <buffer> <C-l> <C-w>l
    imap <buffer> <C-h> <Esc><C-w>h
    imap <buffer> <C-j> <Esc><C-w>j
    imap <buffer> <C-k> <Esc><C-w>k
    imap <buffer> <C-l> <Esc><C-w>l
    nmap <buffer> H gT
    nmap <buffer> L gt
    nmap <buffer> <leader>x :bd!<CR>
endfunction
let g:unite_source_process_enable_confirm = 1
let g:unite_enable_split_vertically = 0
let g:unite_winheight = 20
let g:unite_source_directory_mru_limit = 300
let g:unite_source_file_mru_limit = 300
let g:unite_source_file_mru_filename_format = ':~:.'
nno <leader>a :<C-u>Unite grep -default-action=above<CR>
nno <leader>A :<C-u>execute 'Unite grep:.::' . expand("<cword>") . ' -default-action=above -auto-preview'<CR>
nno <leader>b :<C-u>Unite buffer -buffer-name=buffers -start-insert<CR>
"nno <leader><leader> :<C-u>UniteWithCurrentDir buffer file -buffer-name=united -start-insert<CR>
nno <leader>ps :<C-u>:Unite process -buffer-name=processes -start-insert<CR>
nno <leader>u :<C-u>Unite<space>
""nno <C-p> :<C-u>:Unite history/yank -buffer-name=yanks<CR>
"nno // :<C-u>:Unite line -buffer-name=lines -start-insert -direction=botright -winheight=10<CR>
" wimviki replacement {{{
    map <leader>W :<C-u>Unite file file/new -buffer-name=notes -start-insert
		\ -toggle -default-action=split -profile-name=files
		\ -input=/Volumes/Vimwiki/<CR>
" }}}
" VimFiler {{{
    "let g:vimfiler_data_directory = expand('~/.vim/tmp/vimfiler/')
    "let g:vimfiler_safe_mode_by_default = 0
    "let g:vimfiler_execute_file_list = { "_": "vim" }
    "nno ` :<C-u>:VimFilerBufferDir -buffer-name=explorer -toggle<CR>
    "function! s:vimfiler_settings()
    "    call s:unite_tabs_and_windows()
    "    nmap <buffer> - <Plug>(vimfiler_switch_to_parent_directory)
    "    nmap <buffer> % <Plug>(vimfiler_new_file)
    "    nmap <buffer> <Backspace> <C-^>
    "    nmap <buffer> <leader>x <Plug>(vimfiler_exit)
    "    nmap <buffer> <leader>X <Plug>(vimfiler_exit)
    "endfunction
    "autocmd UniteAutoCmd Filetype vimfiler call s:vimfiler_settings()
" }}}
" Ref {{{
    "let g:ref_use_vimproc = 1
    "let g:ref_open = 'vsplit'
    "let g:ref_cache_dir = expand('~/.vim/tmp/ref_cache/')
    "nno <leader>K :<C-u>Unite ref/erlang -buffer-name=erlang_docs -start-insert -vertical -default-action=split<CR>
" }}}
" netrw {{{
    let g:netrw_http_cmd='curl -0 -k -L -vv'
    let g:netrw_http_xcmd='-o'
"}}}
" }}}
