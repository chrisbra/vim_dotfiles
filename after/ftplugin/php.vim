"-------------------------------------------------------
" Vim Setting for PHP-files
" Christian Brabandt <cb@256bit.org>
"
" Last update: Do 2012-07-05 13:34
"-------------------------------------------------------

" Set C-Indention
set cinoptions=>2,e0,n0,f0,{0,}0,^0,:s,=s,l1,gs,hs,ps,ts,+s,c3,C0,(2s,us,\U0,w0,m0,j0,)20,*30
set cin

" Comment text in visual mode
function! UnComment()
	let s:oldSearch=@/
    s/^\/\/\(.*\)$/\1/
	let @/=s:oldSearch
endfunction
function! Comment()
	let s:oldSearch=@/
    s/^[^//].*$/\/\/&/
	let @/=s:oldSearch
endfunction
vmap <silent> <leader>co :<C-U>sil! '<,'>:call Comment()<CR>
vmap <silent> <leader>uco :<C-U>sil! '<,'>:call UnComment()<CR>
 
let g:nrrw_custom_options={}
let g:nrrw_custom_options['filetype']='php'
