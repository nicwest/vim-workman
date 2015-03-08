let s:suite = themis#suite('core')
let s:assert = themis#helper('assert')

function! s:suite.before() abort
  call ForceLoad('workman')
  let s:sid = GetSID('autoload/workman.vim')
endfunction

function! s:suite.after_each() abort
  let l:unmap_keys = [
        \ 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
        \ 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',
        \ 'z', 'x', 'c', 'v', 'b', 'n', 'm',
        \ 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P',
        \ 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':',
        \ 'Z', 'X', 'C', 'V', 'B', 'N', 'M']
  for l:char in l:unmap_keys
    try
      execute "unmap!" l:char
    catch
    endtry
    try
      execute "unmap" l:char
    catch
    endtry
    try
      execute "unmap <C-" . l:char . ">" 
    catch
    endtry
  endfor
  set langmap=
  norm! gg"_dG
endfunction


