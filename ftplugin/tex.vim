"-------------------------------------------------------
" Vim Setting for LaTeX Files
" Christian Brabandt <cb@256bit.org>
"
" Last update: Di 2009-08-11 20:41
"-------------------------------------------------------
" VIm LaTeX resources

" Loading latex-suite when input file is detected to be tex file
" This should be done automatically, if it does not work, 
" uncomment the following
filetype plugin indent on

" Mache bei LaTeX Dateien latex als ausführende Datei
" Aufruf :make
"set makeprg=latex\ %
set makeprg=pdflatex\ -interaction=nonstopmode\ %

inoremap <buffer> " ,,``<LEFT>
inoremap <buffer> ' ,`<LEFT>

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
setlocal iskeyword+=: 

setlocal tw=75 foldenable

" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
setlocal sw=2 


" This mapping allows to choos in visible mode which region to comment out.
" Just select a region and press ,co
"vmap ,co :s/^\([.]*\)/% \1/<CR>
cmap como :s/^/% /<CR>
" and vice versa (remove the comment signs:
"vmap ,uco :s/^% \([.]*\)/\1/<CR>
cmap comu :s/^% //<CR>


" LaTeX abbrevs
"------------------------------------------------------
" Formatting
iabbrev \i       \textit{}<Left>
iabbrev \b       \textbf{}<Left>
iabbrev \c       \textsc{}<Left>
iabbrev \s       \textsl{}<Left>

" Linking
iabbrev \l       \label{}<Left>
iabbrev \r       \ref{}<Left>
iabbrev \p       \pageref{}<Left>

" item etc.
iabbrev \t       \item
iabbrev \d       \item[]<Left>

" Chapter / Sections / ...
iabbrev \1       \chapter{}<Left>
iabbrev \2       \section{}<Left>
iabbrev \3       \subsection{}<Left>
iabbrev \4       \subsubsection{}<Left>

" Begin-End-Blocks
imap    <C-B>i   \begin{itemize}<CR>  \item <CR><BS><BS>\end{itemize}<UP><END>
imap    <C-B>e   \begin{enumerate}<CR>  \item <CR><BS><BS>\end{enumerate}<UP><END>
imap    <C-B>d   \begin{description}<CR>  \item[] <CR><BS><BS>\end{description}<UP><END>
imap    <C-B>t   \begin{tabular}{}<CR>\end{tabular}<UP><END><LEFT>
imap    <C-B>c   \caption{ \l }<Left>
imap    <C-B>a   \begin{table}[]<CR>  <C-B>t<DOWN><END><CR><BS><BS>\end{table}<UP><UP><END>
imap    <C-B>f   \begin{figure}[]<CR>\end{figure}<UP><UP><END>
