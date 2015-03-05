let s:suite = themis#suite('utils')
let s:assert = themis#helper('assert')

function! s:suite.before() abort
  call ForceLoad('workman')
  let s:sid = GetSID('autoload/workman.vim')
endfunction

function! s:suite.after_each() abort
  let l:unmap_keys = [
        \ 'i', 'y', 'r', 'o', 'p', 'd', 'w', 'h',
        \ 'Y', 'R', 'O', 'P', 'D', 'W', 'H']
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
  norm! gg"_dG
endfunction

function! s:suite.zip_zips_lists() abort
  let l:result = ScriptCall(s:sid, 'zip', ['a', 'b', 'c'], [1, 2, 3])
  let l:expected = [['a', 1], ['b', 2], ['c', 3]]
  call s:assert.equals(l:result, l:expected)
endfunction

function! s:suite.insert_map_sets_lower_keys() abort
  call s:assert.equals(getline(1), '')
  call ScriptCall(s:sid, 'insert_map',
        \ ['h', 'e', 'l', 'o', 'w', 'r', 'd'],
        \ ['y', 'r', 'o', 'p', 'd', 'w', 'h'])
  norm iyroop dpwoh
  call s:assert.equals(getline(1), 'hello world')
endfunction

function! s:suite.insert_map_sets_upper_keys() abort
  call s:assert.equals(getline(1), '')
  call ScriptCall(s:sid, 'insert_map',
        \ ['H', 'E', 'L', 'O', 'W', 'R', 'D'],
        \ ['Y', 'R', 'O', 'P', 'D', 'W', 'H'])
  norm iYROOP DPWOH
  call s:assert.equals(getline(1), 'HELLO WORLD')
endfunction

function! s:suite.normal_map_sets_lower_keys() abort
  call s:assert.equals(getline(1), '')
  call ScriptCall(s:sid, 'normal_map',
        \ ['i', 'h', 'e', 'l', 'o', 'w', 'r', 'd'],
        \ ['u', 'y', 'r', 'o', 'p', 'd', 'w', 'h'])
  norm ihello world
  call s:assert.equals(getline(1), 'hello world')
endfunction

function! s:suite.normal_map_sets_upper_keys() abort
  call s:assert.equals(getline(1), '')
  norm ithis is line!
  call s:assert.equals(getline(1), 'this is line!')
  call ScriptCall(s:sid, 'normal_map',
        \ ['H', 'E', 'L', 'O', 'W', 'R', 'D'],
        \ ['Y', 'R', 'O', 'P', 'D', 'W', 'H'])
  norm PHELLO WORLD
  call s:assert.equals(getline(1), 'HELLO WORLD')
endfunction

"function! s:suite.testhing() abort
  "let l:maps = ''
  "redir => l:maps
  "silent nmap
  "redir END
  "call themis#log(l:maps)
"endfunction
