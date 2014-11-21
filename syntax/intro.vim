
if exists("b:current_syntax")
	finish
endif
syntax match IntroQuit /type :q<Enter>/
highlight link IntroQuit ErrorMsg
let b:current_syntax = "intro"
