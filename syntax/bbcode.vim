" bbcode.vim
" @Author:      Thomas Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-11-15.
" @Last Change: 2007-11-15.
" @Revision:    0.1.48

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif
if version < 508
    command! -nargs=+ HiLink hi link <args>
else
    command! -nargs=+ HiLink hi def link <args>
endif

syn region bbcodeTag matchgroup=Delimiter start=/\[\z(.\{-}\)\(=.\{-}\)\?\]/ end=/\[\/\z1\]/
syn region bbcodeBold matchgroup=Delimiter start=/\[b\]/ end=/\[\/b\]/
syn region bbcodeItalic matchgroup=Delimiter start=/\[i\]/ end=/\[\/i\]/
syn region bbcodeUnderline matchgroup=Delimiter start=/\[u\]/ end=/\[\/u\]/
syn region bbcodeStrikethrough matchgroup=Delimiter start=/\[s\]/ end=/\[\/s\]/
syn region bbcodeUrl matchgroup=Delimiter start=/\[url\(=.\{-}\)\?\]/ end=/\[\/url\]/
syn region bbcodeQuote matchgroup=Delimiter start=/\[quote\(=.\{-}\)\?\]/ end=/\[\/quote\]/
syn region bbcodeCode matchgroup=Delimiter start=/\[code\(=.\{-}\)\?\]/ end=/\[\/code\]/
syn region bbcodeList matchgroup=Delimiter start=/\[list\(=.\{-}\)\?\]/ end=/\[\/list\]/
            \ transparent
syn match bbcodeItem /\[\*\]/

if exists('loaded_viki') && loaded_viki >= 304
    runtime syntax/texmath.vim
    syn region bbcodeTex matchgroup=Delimiter start=/\[tex\(=.\{-}\)\?\]/ end=/\[\/tex\]/
                \ contains=@texmathMath transparent
endif

HiLink bbcodeTag Statement
HiLink bbcodeUrl underlined
HiLink bbcodeQuote Comment
HiLink bbcodeCode PreProc
HiLink bbcodeStrikethrough Ignore
HiLink bbcodeDelimiter Delimiter
HiLink bbcodeItem Delimiter
" HiLink bbcodeTex Identifier

hi bbcodeBold term=bold,underline cterm=bold,underline gui=bold
hi bbcodeItalic term=italic cterm=italic gui=italic
hi bbcodeUnderline term=underline cterm=underline gui=underline

delcommand HiLink
let b:current_syntax = 'bbcode'
