" BufTimer.vim - Timing statistics for your editing session
" ---------------------------------------------------------
" Version:   0.1
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Last Change: Sat, 16 Feb 2013 22:28:31 +0100
"
" Script: http://www.vim.org/scripts/script.php?script_id=3075
" BufTimer Report Plugin: Documentation "{{{2
" Idea: https://groups.google.com/d/msg/vim_use/QgPspne7hRU/NjkFsfgPFjMJ
" Initial Plugin Version: Bill McCarthy 
"    at https://groups.google.com/d/msg/vim_use/Hd1p6iIx9KY/AZ6cXBP9uL4J
" Licence: Vim-License
" 
" Configuration: 
" 
" g:btrOpt: Determines, for which buffers to collect Timing Statistics.
"	    0:  Only consider existing buffers
"	    1:  Only consider listed buffers
"	    2:  Only consider loaded buffers
"	    (default: 0)
"
" g:buftimer_map: Specify, to which key to map the :BufTimer function
"           (default: none) e.g. disabled
"           To specify a key, set in your .vimrc:
"           :let g:buftimer_map = "<leader>bt"
"
" g:buftimer_report_map: Specify, to which key to map the :BufTimerReport function
"           (default: none) e.g. disabled
"           To specify a key, set in your .vimrc:
"           :let g:buftimer_map = "<leader>br"
"
" Plugin Init: "{{{2
if exists("g:loaded_buftimer") ||
      \ &cp ||
      \ !has("autocmd") ||
      \ !has("reltime") ||
      \ v:version < 700
  finish
endif

let g:loaded_buftimer = 1

" Using line continuation
let s:cpo_hold = &cpoptions
set cpoptions&vim

if !exists('g:btrOpt') | let g:btrOpt = 0 | endif

if has("float")
  let s:Str2Nr = function("str2float")
  let s:zero   = 0.0
else
  let s:Str2Nr = function("str2nr")
  let s:zero   = 0
endif

let s:patch831 = v:version > 703 || ( v:version == 703 && has("patch831"))

let s:BTRtitles = ["-----Existing Buffers-----",
	          \"------Loaded Buffers------",
	          \"------Listed Buffers------"]
augroup BufTimer
  autocmd!
  autocmd VimEnter,BufRead,BufNew * if !exists('b:timeStart')
	\| let b:timeStart = reltime() | let b:timeAccum = s:zero | endif
  autocmd BufLeave *	let b:timeAccum = s:BufTimerCalc()
  autocmd BufEnter * 	let b:timeStart = reltime() | if !exists('b:timeAccum')
	\| let b:timeAccum = s:zero | endif
  autocmd FocusGained * let b:timeStart = reltime()
  autocmd FocusLost *   let b:timeAccum = s:BufTimerCalc()
augroup END

if has("float")
  function! s:Secs2Str(secs) "{{{3
    let hours   = floor(a:secs/3600)
    let minutes = floor((a:secs-hours*3600)/60)
    let seconds = a:secs-hours*3600-minutes*60
    return printf("%0.0f:%02.0f:%02.0f",hours,minutes,seconds)
  endfunction!
else
  function! s:Secs2Str(secs) "{{{3
    let hours   = a:secs/3600
    let minutes = (a:secs-hours*3600)/60
    let seconds = a:secs-hours*3600-minutes*60
    return printf("%d:%02d:%02d",hours,minutes,seconds)
  endfunction!
endif


" Functions: "{{{2
function! s:Round(val) "{{{3
  if has("float")
    " Bug? round(0.0) == -0.0
    return a:val == 0.0 ? 0.0 : round(a:val)
  else
    return a:val
  endif
endfunction
function! s:Reltime(buffer) "{{{3
  if a:buffer == bufnr('')
    return reltimestr(reltime(getbufvar(a:buffer, "timeStart")))
  else
    return string(s:zero)
  endif
endfunction
function! s:BufTimerCalc(...) "{{{3
  let bufnr = exists("a:1") ? a:1 : bufnr('')
  let timeAccum = s:patch831 ? getbufvar(bufnr, 'timeAccum', s:zero) :
	\ (getbufvar(bufnr, 'timeAccum') + s:zero)
  return s:Str2Nr(s:Reltime(bufnr)) + timeAccum
endfunction
function! s:BufTimer(...) "{{{3
  let secs = call("s:Round",
	\ [s:BufTimerCalc(exists("a:1") ? a:1 : bufnr(''))])
  if exists('s:total') | let s:total += secs | endif
  return s:Secs2Str(secs)
endfunction
function! s:BufTimerReport(...) "{{{3
  if !exists('g:btrOpt') || g:btrOpt < 0 || g:btrOpt > 2
    echomsg 'Bad g:btrOpt'
    return
  endif
  let filename=''
  if a:0
    let filename=fnameescape(a:1)
  endif
  let s:total = s:zero
  let report = [s:BTRtitles[g:btrOpt],
	      \"Buf  hh:mm:ss  Buffer Name",
	      \"---  --------  -----------"]

  for i in range(1,bufnr('$'))
    if ((!g:btrOpt && bufexists(i))
	      \|| (g:btrOpt == 1 && bufloaded(i))
	      \|| (g:btrOpt == 2 && buflisted(i)))
      let str = printf("%3d %9s  %s", i, s:BufTimer(i), bufname(i))
      call add(report, str)
    endif
  endfor
  call add(report, "---  --------")
  call add(report, printf("Tot %9s",s:Secs2Str(s:total)))

  if empty(filename)
    for i in report
      echo i
    endfor
  else
    let s:report=report
    let s:fname = filename
    aug BufTimer_WriteReport
      au!
      au VimLeave * call s:WriteReport(s:fname, s:report)
    augroup end
  endif

  unlet s:total
endfunction

function! s:WriteReport(filename, report) "{{{3
  if v:dying
    return
  endif

  try
    call writefile(a:report, a:filename)
  catch
    echohl Error
    echo "Error Writing file: '".a:filename.'": '.v:exception
    echohl Normal
    sleep
  endtry
endfunction

" Interface: "{{{2
command! -nargs=? -complete=file BufTimerReport call s:BufTimerReport(<f-args>)
command! BufTimer echo s:BufTimer()

nmap <silent> <Plug>BTRmap :BufTimerReport<CR>
nmap <silent> <Plug>BTmap :BufTimer<CR>

if !hasmapto("<Plug>BTmap") && get(g:, "buftimer_map", "none") != "none"
  "nmap <unique> <leader>dt <Plug>BTmap
  exe "nmap <unique>" g:buftimer_map "<Plug>BTmap"
endif

if !hasmapto("<Plug>BTRmap") && get(g:, "buftimer_report_map", "none") != "none"
  "nmap <unique> <leader>dr <Plug>BTRmap
  exe "nmap <unique>" g:buftimer_report_map "<Plug>BTmap"
endif

" restore 'cpoptions' "{{{2
let &cpoptions = s:cpo_hold
unlet s:cpo_hold

" vim: sw=2 sts=2 ts=8 tw=79
