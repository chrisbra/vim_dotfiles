" F12 -> Attached Screen session: {{{ 
" ============================== 
" Build mapping: {{{ 
" cd $(dirname %:p) --> Change to current file's directory. 
" screen 
"  -U -> Run in UTF-8 mode. 
"  -d -> Deatach if previously attached. 
"  -dRR vim_$(basename %:p) 
"     -> Use current buffer file name as sessionname; then reattach it and, 
"        if necessary, detach or create it first. Use the first session if
"        more than one session with same name are available. 
"  -p %:p   -> Use current buffer file full path as preselected (if 
"       available) window. 
"     * TODO: Create this window by default when not exists. 
"  -c ~/.vim/screenrc 
"     -> Use modified screenrc config file (see below). 
"noremap <f12> :silent<space>!bash<space>-c<space>'cd<space>$(dirname<space>%:p);screen<sp ace>-UdRR<space>vim_${PPID}<space>-e^qa<space>-p<space>"%"<space>-c<space>~ /.vim/screenrc'<enter>:redraw!<enter> 
"""""noremap <f12> :silent<space>!bash<space>-c<space>'cd<space>$(dirname<space>%:p);screen<sp ace>-UdRR<space>vim_${PPID}<space>-p<space>"%"<space>-c<space>~/.vim/screen rc'<enter>:redraw!<enter> 
noremap <f12> :silent<space>!screen<space>-UdRR<space>vim_${PPID}<space>-c<space>~/.vim/screenrc<enter>:redraw!<enter> 
imap <f12> <esc><f12>a 
" }}} 
" Make screen session to be killed on exit and also prompting if dialog is 
" installed: {{{ 
" 
--------------------------------------------------------------------------- ------- 
autocmd VimLeave * !screen -ls vim_${PPID} | grep vim_${PPID} && dialog --yesno "Leave existing screen sessions alive?" 6 40 && screen -r vim_${PPID} || kill $(screen -ls vim_${PPID} | perl -ne 's/^.*?(\d{2,}).*$/\1/&&print') && clear 
" }}} 
" Prepare vim's screen configuration: {{{ 
" ---------------------------------- 
" Create ~/.vim directory if not already exists. 
silent !mkdir -p ~/.vim 
" Create/overwrite with user's ~/.screenrc if exists. 
silent !cat ~/.screenrc > ~/.vim/screenrc 2>/dev/null 
" Bind F12 to 'detach' command in screen. 
silent !echo 'bindkey -k F2 detach' >> ~/.vim/screenrc 
" Change default screen's escape key to CTRL-Q to avoid conflict if vim 
" itself is running in other screen session. 
"silent !echo 'escape ^qa' >> ~/.vim/screenrc 
" }}} 
" }}} 
