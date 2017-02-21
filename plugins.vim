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
"let g:csv_no_column_highlight=1
"let g:csv_highlight_column='y'
"let g:csv_autocmd_arrange_size = 1024*500   " only enable automatic arranging of columns for files less than 1 MB
"aug CSV_Editing
"    au!
"    au BufRead,BufWritePost *.csv :%ArrangeColumn
"    au BufWritePre *.csv :%UnArrangeColumn
"aug end

" ChangesPlugin:
"let g:changes_autocmd=1
" disabled for now
"let g:loaded_changes       = 1
let g:changes_verbose=0
let g:changes_vcs_check=1
let g:changes_fast=0 " slower but possibly more correct
"let g:loaded_changes=1
if !exists("$PUTTY_TERM")
    let g:changes_sign_text_utf8=1
endif
let g:changes_debug=1
let g:changes_fixed_sign_column=1
"let g:changes_linehi_diff=1
"let g:changes_diff_preview=0
" use a different highlighting:
" hi ChangesSignTextAdd ctermbg=yellow ctermfg=black guibg=green
" hi ChangesSignTextDel ctermbg=white  ctermfg=black guibg=red
" hi ChangesSignTextCh  ctermbg=black  ctermfg=white guibg=blue
" disabled
"let g:changes_loaded=1

"let g:changes_diff_preview=1

" CheckAttach:
"let g:checkattach_filebrowser = 'range'

" SudoEdit:
"let g:sudoDebug=1

" Unicode:
let g:enableUnicodeCompletion=1
let g:Unicode_ShowPreviewWindow=1
" slow:
"let g:Unicode_ShowDigraphName = 1
let g:Unicode_ConvertDigraphSubset = [
    \ char2nr("€"),
    \ char2nr("ä"),
    \ char2nr("Ä"),
    \ char2nr("ö"),
    \ char2nr("Ö"),
    \ char2nr("ü"),
    \ char2nr("Ü"),
    \ char2nr("ß") ]

" Plugin-misc:
let g:plugin_misc_no_map_tabular = 1

" Colorizer Plugin:
let g:colorizer_auto_filetype="html,css"
"let g:colorizer_taskwarrior = 0
"let g:colorizer_debug = 1
"let g:colorizer_only_unfolded = 1
"let g:colorizer_skip_comments = 1
let g:colorizer_colornames = 1
let g:colorizer_auto_map = 1
"let g:colorizer_auto_color = 1
"let g:colorizer_syntax=1

" NrwwRgn:
"let b:nrrw_aucmd_close= "unlet! g:nrrw_custom_options"
"let g:nrrw_rgn_nomap_nr = 1

" DynamicSigns:
"let g:Signs_Scrollbar = 1
let g:Signs_Bookmarks = 1
let g:SignsMixedIndentation = 1
"let g:Signs_Diff = 1
let g:Signs_QFList = 0
"let g:Signs_Diff = 1
"let g:Signs_Alternate = 1

" ft_improved
"let g:ft_improved_multichars = 1
let g:ft_improved_ignorecase = 1
"let g:ft_improved_consistent_comma = 1
"let g:ft_improved_nomap_comma = 1
"let g:ft_improved_nohighlight = 0

" DistractFree:
let g:distractfree_colorscheme = "darkroom"
"au BufEnter *.vim call DistractFree#DistractFreeToggle()

" Replay:
let g:replay_record = 1

" ShowWhiteSpace
"let g:showwhite_highlighting = 'ctermfg=7 ctermbg=NONE guifg=LightGrey guibg=NONE'
"nmap <silent> <F5> <Plug>ShowWhiteToggle

" Tmux-Navigator
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>:nohls<cr><c-l>
nnoremap <silent> <C-_> :TmuxNavigatePrevious<cr>

" Airline:
" disable, so that it won't overwrite tmuxline
let g:airline#extensions#tmuxline#enabled = 0
" use a custom silly formatter
"let g:airline#extensions#wordcount#formatter = 'foo'
" enable smart tabline
let g:airline_theme='vice'
let g:airline#extensions#tabline#show_close_button = 0
"let airline#extensions#tabline#show_tabs = 0
"let g:airline_theme = 'powerlineish'
let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#disable_refresh = 1
"let g:airline#extensions#ycm#enabled = 1
"let g:airline#extensions#tabline#fnametruncate = 1
"let g:airline#extensions#whitespace#enabled = 0
"let airline#extensions#default#section_use_groupitems = 1
let g:airline_powerline_fonts = 1
"let g:airline_skip_empty_sections = 1
" enable/disable detection of whitespace errors. >
"let g:airline#extensions#whitespace#enabled = 1
"let g:airline#extensions#tabline#buffer_idx_mode = 1
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
  nmap <leader>- <Plug>AirlineSelectPrevTab
  nmap <leader>+ <Plug>AirlineSelectNextTab
"let airline#extensions#whitespace#mixed_indent_algo = 1
"let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#tabline#fnamemod = ':t:.'
"let g:airline_section_a = airline#section#create_right(['tagbar', ' ', 'filetype'])
"let g:airline_section_y = airline#section#create_right(['filetype'])
"let g:airline_section_x = ''
if !exists("g:airline_symbols")
  let g:airline_symbols = {}
endif
" unicode symbols
"let g:airline_left_sep = '»'
if !exists("$PUTTY_TERM")
  "let g:airline_left_sep = '▶'
  "let g:airline_right_sep = '«'
  "let g:airline_right_sep = '◀'
  "let g:airline_symbols.branch = '⎇'
else
  let g:airline_left_sep = '»'
  let g:airline_left_alt_sep = '>'
  let g:airline_right_sep = '«'
  let g:airline_right_alt_sep = '<'
  let g:airline_symbols.branch = ''
  let g:airline_symbols.notexists = '!'
endif
"let g:airline_symbols.linenr = '␊'
"let g:airline_symbols.linenr = '␤'
"let g:airline_symbols.linenr = '¶'
"let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.linenr = ''
"let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.readonly = 'RO'
let g:airline_symbols.space = ' '

" Solarized Colorscheme:
"let g:solarized_termcolors=256
"colors solarized

" Tmuxline Integration:
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'b'    : '#W',
      \'c'    : '#H',
      \'win'  : '#I #W',
      \'cwin' : '#I #W',
      \'x'    : '%a',
      \'y'    : '#W %R',
      \'z'    : '#H'}

let g:tmuxline_preset = {
      \'a'    : '#S',
      \'c'    : ['#(whoami)', '#(uptime | cud -d " " -f 1,2,3)'],
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W', '#F'],
      \'x'    : '#(date)',
      \'y'    : ['%R', '%a', '%Y'],
      \'z'    : '#H'}

let g:tmuxline_preset = {
      \'a'    : '#S',
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W', '#F'],
      \'y'    : ['%R', '%a', '%Y'],
      \'z'    : '#H'}

let g:tmuxline_powerline_separators=0

" vim-gitgutter:
" disabled
let g:gitgutter_enabled = 0

" Syntastic: only use passive mode
let g:syntastic_mode_map = { 'mode': 'passive',
                            \ 'active_filetypes': [],
                            \ 'passive_filetypes': [] }

" Neocomplete requires if_lua
if !has('lua')
    let g:loaded_neocomplete = 0
endif

let g:zsh_fold_enable=1
