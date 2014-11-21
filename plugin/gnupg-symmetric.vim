"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filename:     gnupg-symmetric.vim
"
" Date:         November 11, 2005
"
" Version:      1.0
"
" Author:       Konstantin Rozinov <krozinov@yahoo.com>
"               Any bug reports, comments, suggestions, or ideas would be
"               appreciated.
"
" Description:  This script allows you to work with GPG-encrypted files
"               transparently through VIM.  Unlike other gpg vim scripts, this
"               one works with files that have been encrypted only with a
"               passphrase (--symmetric).  It is designed to be secure and
"               robust.
"
" Installation: Add the following line to your ~/.vimrc file:
"               :source /path/to/gnupg-symmetric.vim
"
" Todo:         1. clear terminal window/prevent scrolling
"               2. enable appending to other encrypted files
"               3. writing to new files (i.e. :w newfilename.gpg)
"               
" Thanks:       The following folks gave me ideas and technical advice:
"               Herb Wartens, Ira Weiny, Hari Krishna Dara, Tim Chase,
"               A. J. Mechelynck, Markus Braun, VIM User Mailing list
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set various security settings
function! s:init()
	" Disable swap file, history, viminfo file, and backups. 
	set secure
	set viminfo=
	set noswapfile
	set nobackup
	set nowritebackup
	set history=0
endfunction

" Clear as many registers as possible to prevent copying unencrypted text.
function! s:clear_registers()
	let regs='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"-/_'
	let i=0 
	while (i < strlen(regs))
		exec "let @".regs[i]."=''"
		let i=i+1
	endwhile
	unlet i
	unlet regs
endfunction

" Decrypt the file.
function! s:gpg_decrypt()
	" Decrypt the file, prompting for the passphrase.
	:%!gpg --quiet --decrypt 2>/dev/null
	" If the passphrase is incorrect or the decryption fails, then quit immediately.
	if (v:shell_error)
		echo "gpg: decryption failed: bad key!\n"
		q!
	endif
	" Switch to normal mode to read unencrypted data.
	set nobin
	" Restore the original command line window height.
	set ch=1
	" Once the data has been unencrypted, clear the registers to prevent copying of unencrypted data.
	call s:clear_registers()
endfunction

" Encrypt the file.
function! s:gpg_encrypt()
	" Switch to binary mode prior to encrypting data.
	set bin
	" Remove the temporary encrypted file.
	silent :!rm -f %~
	" Encrypt the current buffer into the temporary file.
	silent :%!gpg --quiet --symmetric --cipher-algo AES --output %~ 2>/dev/null
	" Undo the encryption, so we see the unencrypted text.
	undo
	" After writing encrypted data, switch back to normal mode.
	set nobin
	" If the encryption was successful, clear the modified flag.
	if (filereadable(expand("%")."~"))
		set nomodified
	else
		echo "gpg: symmetric encryption of " . expand("%") . " failed: invalid passphrase!\n" . expand("%") . " not saved!\n"
	endif
endfunction

" Steps to take when exiting vim.
function! s:exit()
	" If the temporary encrypted file exists, move it over to original file.
	if filereadable(expand("%")."~")
		silent :!mv -f %~ %
	endif
	" Upon leaving vim, delete the file contents from screen, refresh the vim screen, and reset the terminal (in an effort to conceal any unencrypted text).
	"bwipeout!
	"bdelete!
	:0,$d
	:redraw
	:!clear && reset
endfunction

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  	" Settings for GnuPG-encrypted (symmetric only) files
	augroup GPG
	" Remove all GPG autocommands, prior to defining them below.
	au!
		" Initialize security settings
		autocmd BufNewFile,BufReadPre,FileReadPre		*.gpg call s:init()

		" Switch to binary mode to read the encrypted data. 
		autocmd BufReadPre,FileReadPre				*.gpg set bin
		" Set the command line window height so that it's not garbled. 
		autocmd BufReadPre,FileReadPre				*.gpg set ch=3

		" Decrypt the file.
		autocmd BufReadPost,FileReadPost			*.gpg call s:gpg_decrypt()

		" Prior to writing the date to file, we must encrypt it and prompt for a new passphrase.
		"autocmd BufWritePre,FileWritePre			*.gpg call s:gpg_encrypt()
		autocmd BufWriteCmd					*.gpg call s:gpg_encrypt()

		" Clear the registers upon various events (this prevents copying to other files/windows/buffers)
		autocmd VimLeave,BufHidden,BufDelete,BufLeave,BufUnload,BufWinLeave,BufWipeout,FocusLost,WinLeave	*.gpg call s:clear_registers()
		autocmd BufUnload,BufDelete,BufWipeout,VimLeave		*.gpg call s:exit()
	augroup END
endif
