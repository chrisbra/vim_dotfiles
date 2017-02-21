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
" Commands:
" :BufTimer - Print the time spent in the current Buffer
" :BufTimerReport - Print a report about the time spent in all buffers
" :BufTimerReport filename - Print a report about the time spent in all buffers
"                            when Vim quits to 'filename'
" Plugin Init: "{{{2
if &cp
  finish
endif
if exists("g:loaded_buftimer") ||
      \ !has("autocmd") ||
      \ !has("reltime") ||
      \ !has("float") ||
      \ v:version < 704
  finish
endif

let g:loaded_buftimer = 1

" Using line continuation
let s:cpo_hold = &cpoptions
set cpoptions&vim

if !exists('g:btrOpt') | let g:btrOpt = 0 | endif

  let s:Str2Nr = function("str2float")
  let s:zero   = s:Str2Nr("0.0")

let s:BTRtitles = ["-----Existing Buffers-----",
	          \"------Loaded Buffers------",
	          \"------Listed Buffers------"]
augroup BufTimer
  autocmd!
  autocmd VimEnter,BufRead,BufNew * if !exists('b:timeStart') | let b:timeStart = reltime() | let b:timeAccum = s:zero | endif
  autocmd BufLeave *	let b:timeAccum = s:BufTimerCalc()
  autocmd BufEnter * 	let b:timeStart = reltime() | if !exists('b:timeAccum') | let b:timeAccum = s:zero | endif
  autocmd FocusGained * let b:timeStart = reltime()
  autocmd FocusLost *   let b:timeAccum = s:BufTimerCalc()
  autocmd CursorMoved,CursorMovedI,CursorHold,CursorHoldI * call s:BufTimerCheck()
augroup END

" Periodically save the report automatically.
" Set this to the auto-save interval in minutes.
" 0 disables the feature (default)
if !exists('g:buf_report_autosave_periodic')
  let g:buf_report_autosave_periodic = 0
else
  autocmd CursorHold,CursorHoldI * call s:autoSavePeriodic()
endif

if !exists('g:buf_report_autosave_dir')
  let g:buf_report_autosave_dir = "/tmp"
endif


" Functions: "{{{2
function! s:Secs2Str(secs) "{{{3
  if has("float")
    let hours   = floor(a:secs/3600)
    let minutes = floor((a:secs-hours*3600)/60)
    let seconds = a:secs-hours*3600-minutes*60
    return printf("%0.0f:%02.0f:%02.0f",hours,minutes,seconds)
  else
    let hours   = a:secs/3600
    let minutes = (a:secs-hours*3600)/60
    let seconds = a:secs-hours*3600-minutes*60
    return printf("%d:%02d:%02d",hours,minutes,seconds)
  endif
endfunction!

function! s:BufTimerCheck()
  " Check for inactivity
  let g:timeTick = get(g:,'timeTick', reltime())
  let current    = reltime()
  let timediff = str2float(reltimestr(reltime(g:timeTick, current)))
  if  timediff > (15*60+0.0)
    let g:timeIgnore = get(g:, 'timeIgnore', 0.0) + timediff
  endif
  let g:timeTick = current
endfunction

function! s:Round(val) "{{{3
    " Bug? round(0.0) == -0.0
    return a:val == 0.0 ? 0.0 : round(a:val)
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
  let timeAccum = getbufvar(bufnr, 'timeAccum', s:zero)
  return s:Str2Nr(s:Reltime(bufnr)) + timeAccum
endfunction

function! s:BufTimer(...) "{{{3
  let secs = call("s:Round",
	\ [s:BufTimerCalc(exists("a:1") ? a:1 : bufnr(''))])
  if exists('s:total') | let s:total += secs | endif
  return s:Secs2Str(secs)
endfunction

function! s:BufTimeGenerateReport(...) "{{{3
  if !exists('g:btrOpt') || g:btrOpt < 0 || g:btrOpt > 2
    echomsg 'Bad g:btrOpt'
    return
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
  call add(report, printf("Total %9s",s:Secs2Str(s:total)))
  call add(report, printf("Inact %9s",s:Secs2Str(get(g:, 'timeIgnore', 0.0))))
  call add(report, "---  --------")

  unlet s:total

  return report
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

  let opts = g:btrOpt
  let report = s:BufTimeGenerateReport(opts)

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
endfunction

function! s:autoSavePeriodic() " {{{3
  " Automatically saves the current report every few minutes.
  " Called by the [CursorHold] [] and [CursorHoldI] [] automatic
  "
  " [CursorHold]: http://vimdoc.sourceforge.net/htmldoc/autocmd.html#CursorHold
  " [CursorHoldI]: http://vimdoc.sourceforge.net/htmldoc/autocmd.html#CursorHoldI
  " [updatetime]: http://vimdoc.sourceforge.net/htmldoc/options.html#%27updatetime%27
  "
  if g:buf_report_autosave_periodic > 0
    let interval = g:buf_report_autosave_periodic "
    if exists('g:buf_report_last_flushed')
      let next_save = g:buf_report_last_flushed + interval
    else
      let next_save = 0
    end

    let s:opts = g:btrOpt
    let s:report = s:BufTimeGenerateReport(s:opts)

    let s:fname = g:buf_report_autosave_dir . "/buftimer_report."
    let s:fname = s:fname . getpid() . "." . strftime("%Y.%m.%d")

    if localtime() > next_save
      call s:WriteReport(s:fname, s:report)
      let g:buf_report_last_flushed = localtime()
    endif
  endif

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
