"-------------------------------------------------------
" Vim Settings for Perl files
" Christian Brabandt <cb@256bit.org>
"
" Last update: Fr 2006-09-29 00:55
"-------------------------------------------------------

" Set Perl-Indention
"set cinoptions=>2,e0,n0,f0,{0,}0,^0,:s,=s,l1,gs,hs,ps,ts,+s,c3,C0,(2s,us,\U0,w0,m0,j0,)20,*30
"set cin

" Set the makeprg to `perl -W -c <filename> '
set makeprg=perl\ -W\ -c\ %<

" Comment text in visual mode
" select a region and press ,co
cmap como :s/^/# /<CR>
" and vice versa: ,uco
cmap comu :s/^# //<CR>

" Set Smartindent and Tabstop=4 (I do not like soo wide indents)
set smartindent ts=4

" Foldmethod: Marker
set foldmethod=marker
