lang C
set verbose=1

augroup SyncViminfo
    au!
    au FocusGained * :rviminfo! 
    au FocusLost * :wviminfo "Merge infos into .viminfo
aug end
