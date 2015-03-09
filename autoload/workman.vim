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

" Undo: {{{1
let s:remap = []

function! s:get_remap() abort
  return s:remap
endfunction

function! s:reset_remap() abort
  let s:remap = []
endfunction


" Private Functions: {{{1
function! s:zip(a, b) abort
  return map(copy(a:a), '[v:val, a:b[v:key]]')
endfunction

function! s:insert_map(to, from) abort
  for [to_key, from_key] in s:zip(a:to, a:from)
    execute "noremap!" from_key to_key 
  endfor
endfunction

function! s:escape_char(char) abort
  if a:char == ';' || a:char == ','
    return '\\' . a:char
  elseif a:char == '\'
    return '\\'
  else
    return a:char
  endif
endfunction

function! s:get_recursive_key(key, to, from) abort
  return a:from[index(a:to, a:key, 0, 1)]
endfunction

function! s:normal_map(to, from) abort
  let l:langmap = ''
  for [to_key, from_key] in s:zip(a:to, a:from)
    let l:langmap .= s:escape_char(from_key) . s:escape_char(to_key) . ","
    if has("patch502") && &langnoremap && tolower(from_key) ==# from_key && to_key !=# from_key
      let l:current_control_map = maparg("<C-" . from_key . ">", "", 0, 1)
      if l:current_control_map != {}
        call add(s:remap, [
              \ "<C-" . toupper(s:get_recursive_key(from_key, a:to, a:from)) . ">",
              \ l:current_control_map])
      endif
      execute "noremap <C-" . toupper(from_key) . "> <C-" . toupper(to_key) . ">"
    endif
  endfor
  for [l:map_key, l:map] in s:remap
    let l:mode = l:map.noremap ? l:map.mode . "noremap " : l:map.mode . "map "
    let l:silent = l:map.silent ? "<silent> ": ""
    let l:buffer = l:map.buffer ? "<buffer> ": ""
    execute l:mode . l:silent . l:buffer . l:map_key . " " . l:map.rhs
  endfor
  execute 'set langmap=' . l:langmap[:-2]
endfunction

function! s:undo_map() abort
  set langmap=
  for l:key in s:qwerty
    try
      execute "unmap!" l:key
    catch
    endtry
    try
    execute "unmap <C-" . l:key . ">"
    catch
    endtry
  endfor
  try
    for [_, l:map] in s:remap
      let l:mode = l:map.noremap ? l:map.mode . "noremap " : l:map.mode . "map "
      let l:silent = l:map.silent ? "<silent> ": ""
      let l:buffer = l:map.buffer ? "<buffer> ": ""
      execute l:mode . l:silent . l:buffer . l:map.lhs . " " . l:map.rhs
    endfor
  finally
    call s:reset_remap()
  endtry
endfunction

" Library Interface: {{{1
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

function! workman#undo() abort
  call s:undo_map()
endfunction

" Teardown: {{{1
let &cpo = s:save_cpo

" Misc: {{{1
" vim: set ft=vim ts=2 sw=2 tw=78 et fdm=marker:
