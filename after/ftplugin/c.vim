"-------------------------------------------------------
" Vim Setting for C-files
" Christian Brabandt <cb@256bit.org>
"
" Last update: Di 2012-07-10 21:46
"-------------------------------------------------------
" VIm Configuration for C-files

" Set C-Indention
set cinoptions=e0,n0,f0,{0,}0,^0,:s,=s,l1,gs,hs,ps,ts,+s,c3,C0,(2s,us,\U0,w0,m0,j0,)20,*30
set cin

" Set the makeprg to `gcc -O2 -Wall -o <filename> <filename.ext>'
set makeprg=gcc\ -O2\ -Wall\ -o\ %<\ %

" Comment text in visual mode
" select a region and press ,co
"vmap ,co :s/^\(.*\)/\/* \1 *\//<CR>
"cmap como :s/^\(.*\)/\/* \1 *\//<CR>
" and vice versa: ,uco
"cmap comu :s/^\/\* \(.*\)\*\//\1/<CR>
"vmap ,uco :s/^\/\* \(.*\)\*\//\1/<CR>
