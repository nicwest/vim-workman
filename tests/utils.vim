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
  call ScriptCall(s:sid, 'reset_remap')
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

function! s:suite.normal_map_control_keys() abort
  call ScriptCall(s:sid, 'normal_map', ['t'], ['f'])
  call s:assert.equals(maparg('<C-F>'), '<C-T>')
endfunction

function! s:suite.normal_map_doesnt_map_control_keys_on_lowercase() abort
  call ScriptCall(s:sid, 'normal_map', ['T'], ['F'])
  call s:assert.equals(maparg('<C-F>'), '')
endfunction

function! s:suite.normal_map_doesnt_map_control_keys_when_to_and_from_are_equal() abort
  call ScriptCall(s:sid, 'normal_map', ['t'], ['t'])
  call s:assert.equals(maparg('<C-T>'), '')
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

function! s:suite.normal_map_stores_original_maps_so_they_can_be_remapped() abort
  nnoremap <C-F> :call append(0, 'hello world!')<CR>
  call ScriptCall(s:sid, 'normal_map', ['t', 'f', 'r'], ['r', 't', 'f'])
  let l:remaps = ScriptCall(s:sid, 'get_remap')
  call s:assert.equals(len(l:remaps), 1)
  call s:assert.equals(l:remaps[0][0], '<C-T>')
  call s:assert.equals(l:remaps[0][1].lhs, '<C-F>')
  call s:assert.equals(l:remaps[0][1].rhs, ':call append(0, ''hello world!'')<CR>')
endfunction

function! s:suite.normal_map_remaps_bound_control_keys() abort
  noremap <C-F> :call append(0, 'hello world!')<CR>
  call ScriptCall(s:sid, 'normal_map', ['t', 'f', 'r'], ['r', 't', 'f'])
  let l:fmap = maparg('<C-F>', 'n', 0, 1)
  let l:tmap = maparg('<C-T>', 'n', 0, 1)
  call s:assert.equals(l:fmap.rhs, '<C-R>')
  call s:assert.equals(l:tmap.rhs, ':call append(0, ''hello world!'')<CR>')
endfunction

function! s:suite.normal_map_remaps_bound_control_keys_keeps_attributes() abort
  vmap <silent> <C-F> :call append(0, 'hello world!')<CR>
  call ScriptCall(s:sid, 'normal_map', ['t', 'f', 'r'], ['r', 't', 'f'])
  let l:tmap = maparg('<C-T>', 'v', 0, 1)
  call s:assert.equals(l:tmap.rhs, ':call append(0, ''hello world!'')<CR>')
  call s:assert.equals(l:tmap.mode, 'v')
  call s:assert.equals(l:tmap.noremap, 0)
  call s:assert.equals(l:tmap.silent, 1)
endfunction

function! s:suite.normal_map_remaps_bound_control_keys_agnostically() abort
  vmap <silent> <C-F> :call append(0, 'hello world!')<CR>
  call ScriptCall(s:sid, 'normal_map', ['t', 'f', 'r'], ['r', 't', 'f'])
  let l:fmap = maparg('<C-F>', 'v', 0, 1)
  call s:assert.equals(l:fmap.rhs, '<C-R>')
  call s:assert.equals(l:fmap.mode, ' ')
  call s:assert.equals(l:fmap.noremap, 1)
  call s:assert.equals(l:fmap.silent, 0)
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

function! s:suite.undo_unmaps_control_bindings() abort
  map <C-F> :call append(0, 'hello world')<CR>
  call ScriptCall(s:sid, 'undo_map')
  call s:assert.equals(maparg('<C-F>', 'n', 0, 1), {})
endfunction

function! s:suite.undo_remaps_original_bindings() abort
  map <C-F> :call append(0, 'hello world!')<CR>
  call ScriptCall(s:sid, 'normal_map', ['t', 'f', 'r'], ['r', 't', 'f'])
  let l:tmap = maparg('<C-T>', 'n', 0, 1)
  call s:assert.equals(l:tmap.rhs, ':call append(0, ''hello world!'')<CR>')
  call ScriptCall(s:sid, 'undo_map')
  call s:assert.equals(maparg('<C-F>', 'n', 0, 1).rhs, ':call append(0, ''hello world!'')<CR>')
endfunction
