"-------------------------------------------------------
" Vim Setting for TeX Files
" Christian Brabandt <cb@256bit.org>
"
" Last update: So 2007-11-04 21:33
"-------------------------------------------------------

" Mache bei LaTeX latex als ausführende Datei
" Aufruf :make
 set makeprg=pdflatex\ -interaction\ scrollmode\ %
"----
" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
set sw=2 
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=: 
" Loading latex-suite when input file is detected to be tex file
filetype plugin indent on

" This mapping allows to choos in visible mode which region to comment out.
" Just select a region and press ,co
"vmap ,co :s/^\([.]*\)/% \1/<CR>
" and vice versa (remove the comment signs:
"vmap ,uco :s/^% \([.]*\)/\1/<CR>
setlocal tw=75 foldenable

inoremap <buffer> " ,,``<LEFT>
inoremap <buffer> ' ,`<LEFT>
