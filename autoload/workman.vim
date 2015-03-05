" Vimscript Setup: {{{1
let s:save_cpo = &cpo
set cpo&vim

" Chars: {{{1

let s:qwerty = [
      \ 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
      \ 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',
      \ 'z', 'x', 'c', 'v', 'b', 'n', 'm',
      \ 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P',
      \ 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':',
      \ 'Z', 'X', 'C', 'V', 'B', 'N', 'M']

let s:workman = [
      \ 'q', 'd', 'r', 'w', 'b', 'j', 'f', 'u', 'p', ';',
      \ 'a', 's', 'h', 't', 'g', 'y', 'n', 'e', 'o', 'i',
      \ 'z', 'x', 'm', 'c', 'v', 'k', 'l',
      \ 'Q', 'D', 'R', 'W', 'B', 'J', 'F', 'U', 'P', ':',
      \ 'A', 'S', 'H', 'T', 'G', 'Y', 'N', 'E', 'O', 'I',
      \ 'Z', 'X', 'M', 'C', 'V', 'K', 'L' ]

function! s:zip(a, b) abort
  return map(copy(a:a), '[v:val, a:b[v:key]]')
endfunction

function! s:insert_map(to, from) abort
  for [to_key, from_key] in s:zip(a:to, a:from)
    execute "noremap!" from_key to_key 
  endfor
endfunction

function! s:normal_map(to, from) abort
  for [to_key, from_key] in s:zip(a:to, a:from)
    execute "noremap" from_key to_key
    if tolower(from_key) == from_key
      execute "noremap <C-" . from_key . "> <C-" . to_key . ">"
    endif
  endfor
endfunction

function! workman#insert_workman() abort
  call s:insert_map(s:workman, s:qwerty)
endfunction

function! workman#normal_workman() abort
  call s:normal_map(s:workman, s:qwerty)
endfunction

function! workman#insert_qwerty() abort
  call s:insert_map(s:qwerty, s:workman)
endfunction

function! workman#normal_qwerty() abort
  call s:normal_map(s:qwerty, s:workman)
endfunction

" Teardown: {{{1
let &cpo = s:save_cpo

" Misc: {{{1
" vim: set ft=vim ts=2 sw=2 tw=78 et fdm=marker:
