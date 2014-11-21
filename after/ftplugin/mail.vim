"-------------------------------------------------------
" Vim Setting for writing Mails
" Christian Brabandt <cb@256bit.org>
"
" Last update: Do 2009-10-08 23:24
"-------------------------------------------------------
" Called when I am editing files

"setlocal foldmethod=expr foldlevel=1 foldminlines=2 
"setlocal foldexpr=strlen(substitute(substitute(getline(v:lnum),'\\s','','g'),'[^>].*­','','')) 
"setlocal foldexpr=strlen(substitute(getline(v:lnum),'\\s*\\ze>\\\|.*','','g'))

setl tw=70

" I don't like desert256 for mails
"colorscheme desert256
" allow to automatically format messages in insert mode
" see :h fo-table
setl fo+=aw
" instead of tabs, insert spaces
setl et 
"au BufRead /tmp/mutt* normal :g/^> -- $/,/^$/-1d^M/^$^M^L
autocmd FileType mail nmap  <F9> :w<CR>:!aspell -e -c %<CR>:e<CR>

" enable Spell Checking
if version >= 700
    setl spell spelllang=de,en
endif

" Mail.vim Configuration
" See: http://www.vim.org/scripts/script.php?script_id=99
" and also :h mail.txt
"map <buffer> <unique> <LocalLeader>mfp <Plug>MailFormatParagraph

" Default File to get E-Mail Aliases from
let g:mail_alias_source = "Abook"
" Default mutt alias file
let g:mail_mutt_alias_file = "~/.mutt/aliases"
" Delete quoted Signatures
" let g:mail_erase_quoted_sig = 1
" Remove empty quoted lines
"let g:mail_delete_empty_quoted = 1

" Enable referencing of URIs as footnotes. 
" This is mapped to <F11> by default. Press <F11>, enter the URI enter
" and enter a reference number
" Pressing <F12> will move the URI on which the cursor stands
" to the end of the mail and insert a Reference for that URI.
source ~/.vim/plugin/uri-ref.vim


" Mapping of :wq to call the spellchecking function, as I usually forget to 
" check what I've written down
"map! q ! sed -e '/^[A-Z][a-z]*:/ D' % 

" Insert separator lines by using comment marker:
iab Y-" <ESC>71a"<ESC>A
iab Y-% <ESC>71a%<ESC>A
iab Y-# <ESC>71a#<ESC>A
iab Y-! <ESC>71a!<ESC>A
iab Y-- <ESC>71a-<ESC>A

" Translate word under cursor from (English to German)
map ,ed :!translate -ni <cword><CR>
" Tranlate word under cursor from (German to English)
map ,de :!translate -in <cword><CR> 

" Kill quoted Signature
map ,dqs G?^> *-- $<CR>dG

" Make Message urgent:
map ,mu 1G}OPriority: urgent<ESC>


" Delete '(was old Subject)' in Subject
map ,mds 1G/^Subject: /<CR>:s,(was: .*)$<CR>f l

" Squeeze empty lines - join multiple empty lines
nmap ,sl :g/^$/,/./-j<CR>

" Insert an [] to indicate deleted text
" Mark a Textblock in visual mode and then press ',dt'
vmap ,dt c[...]
vmap ,DT c> [

" Mark some lines for quotes
vmap ,qq <ESC>'<O--- Quote begin ---<ESC>'>o--- Quote end ---<ESC>o<ESC>

" Mark some lines for code
vmap ,cc <ESC>'<O<--- Cut here ---><ESC>'>o<--- Cut here ---><ESC>o<ESC>

" Change Subject
" Change from 'Subject: old' to Subject: new (was: old)
"map ,mcs 1G/^Subject: /<CR>:s,\(Subject: \)\(Re: \)*\(.*\)$,\1(was: \3),<CR>f(i

"set verbose=12

"ru! posting.vim
" Files in $HOME/.vim/after/ftplugin/mail/ are automatically sourced,
" good to know, I just found out by accident ;)
"source $HOME/.vim/after/ftplugin/mail/lbdbq.vim
"source $HOME/.vim/lbdbq.vim
