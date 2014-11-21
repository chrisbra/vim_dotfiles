"-------------------------------------------------------
" Vim Setting for Java files
" Christian Brabandt <cb@256bit.org>
"
" Last update: Fr 2005-09-02 10:40
"-------------------------------------------------------

" VIm Configuration for Java-files
" 

" Set Java-Indention 
set cinoptions=>2,e0,n0,f0,{0,}0,^0,:s,=s,l1,gs,hs,ps,ts,+s,c3,C0,(2s,us,\U0,w0,m0,j0,)20,*30
set cin

" Set the makeprg to `javac <filename.java>'
set makeprg=javac\ %


" Comment text in visual mode
" select a region and press ,co
cmap como :s/^\(.*\)/\/* \1 *\//<CR>
" and vice versa: ,uco
cmap comu :s/^\/\* \(.*\)\*\//\1/<CR>
