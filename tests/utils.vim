let s:suite = themis#suite('utils')
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

function! s:suite.zip_zips_lists() abort
  let l:result = ScriptCall(s:sid, 'zip', ['a', 'b', 'c'], [1, 2, 3])
  let l:expected = [['a', 1], ['b', 2], ['c', 3]]
  call s:assert.equals(l:result, l:expected)
endfunction

function! s:suite.insert_map_sets_lower_keys() abort
  call ScriptCall(s:sid, 'insert_map', ['i'], ['u'])
  call s:assert.equals(maparg('u', 'i'), 'i')
endfunction

function! s:suite.insert_map_sets_upper_keys() abort
  call ScriptCall(s:sid, 'insert_map', ['I'], ['U'])
  call s:assert.equals(maparg('U', 'i'), 'I')
endfunction

function! s:suite.escape_char_escapes_semi_colon() abort
  let l:escaped_char = ScriptCall(s:sid, 'escape_char', ';')
  call s:assert.equals(l:escaped_char, '\\;')
endfunction

function! s:suite.escape_char_escapes_comma() abort
  let l:escaped_char = ScriptCall(s:sid, 'escape_char', ',')
  call s:assert.equals(l:escaped_char, '\\,')
endfunction

function! s:suite.escape_char_escapes_backslash() abort
  let l:escaped_char = ScriptCall(s:sid, 'escape_char', '\')
  call s:assert.equals(l:escaped_char, '\\')
endfunction

function! s:suite.normal_map_sets_langmap_lower_keys() abort
  call ScriptCall(s:sid, 'normal_map', ['i'], ['u'])
  call s:assert.equals(&langmap, 'ui')
endfunction

function! s:suite.normal_map_sets_langmap_upper_keys() abort
  call ScriptCall(s:sid, 'normal_map', ['I'], ['U'])
  call s:assert.equals(&langmap, 'UI')
endfunction

function! s:suite.normal_map_sets_langmap_multiple_keys() abort
  call ScriptCall(s:sid, 'normal_map', ['i', 'I'], ['u', 'U'])
  call s:assert.equals(&langmap, 'ui,UI')
endfunction

function! s:suite.normal_map_maps_control_key_combinations() abort
  call ScriptCall(s:sid, 'normal_map', ['D'], ['H'])
  call s:assert.equals(maparg('<C-H>', 'n'), '<C-D>')
endfunction

function! s:suite.get_recursive_key_returns_correct_key() abort
  let l:to = ['t', 'f', 'r']
  let l:from = ['r', 't', 'f']
  let l:recursive_key_t = ScriptCall(s:sid, 'get_recursive_key', 't', l:to, l:from)
  let l:recursive_key_f = ScriptCall(s:sid, 'get_recursive_key', 'f', l:to, l:from)
  let l:recursive_key_r = ScriptCall(s:sid, 'get_recursive_key', 'r', l:to, l:from)
  call s:assert.equals(l:recursive_key_t, 'r')
  call s:assert.equals(l:recursive_key_f, 't')
  call s:assert.equals(l:recursive_key_r, 'f')
endfunction

function! s:suite.undo_resets_langmap() abort
  set langmap=tr,ft,rf
  call ScriptCall(s:sid, 'undo_map')
  call s:assert.equals(&langmap, '')
endfunction

function! s:suite.undo_unmaps_insert_bindings() abort
  map! t f
  call ScriptCall(s:sid, 'undo_map')
  call s:assert.equals(maparg('t', 'i', 0, 1), {})
endfunction

function! s:suite.undo_unmaps_normal_control_key_combinations() abort
  map <C-A> <C-B>
  call ScriptCall(s:sid, 'undo_map')
  call s:assert.equals(maparg('<C-A>', 'n', 0, 1), {})
endfunction
