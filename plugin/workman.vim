" Vimscript Setup: {{{1
let s:save_cpo = &cpo
set cpo&vim

" load guard
" uncomment after plugin development.
"if exists("g:loaded_workman")
"  let &cpo = s:save_cpo
"  finish
"endif
"let g:loaded_workman = 1

" Options: {{{1
if !exists('g:workman_insert_qwerty')
  let g:workman_insert_qwerty = 0
endif

if !exists('g:workman_normal_qwerty')
  let g:workman_normal_qwerty = 0
endif

if !exists('g:workman_insert_workman')
  let g:workman_insert_workman = 0
endif

if !exists('g:workman_normal_workman')
  let g:workman_normal_workman = 0
endif

" Functions: {{{1
function! s:workman(normal) abort
  if a:normal
    let g:workman_normal_workman = 1
    let g:workman_normal_qwerty = 0
    call workman#normal_workman()
    echo "normal: WORKMAN"
  else
    let g:workman_insert_workman = 1
    let g:workman_insert_querty = 0
    call workman#insert_workman()
    echo "insert: WORKMAN"
  endif
endfunction

function! s:qwerty(normal) abort
  if a:normal
    let g:workman_normal_qwerty = 1
    let g:workman_normal_workman = 0
    call workman#normal_qwerty()
    echo "normal: QWERTY"
  else
    let g:workman_insert_querty = 1
    let g:workman_insert_workman = 0
    call workman#insert_qwerty()
    echo "insert: QWERTY"
  endif
endfunction

" Commands: {{{1
command! -bang Workman :call s:workman("<bang>" == "!") 
command! -bang Qwerty :call s:qwerty("<bang>" == "!") 
command! WorkmanUndo :call workman#undo()

" Init: {{{1
func s:init() abort
  if g:workman_normal_workman
    call workman#normal_workman()
  endif

  if g:workman_insert_workman
    call workman#insert_workman()
  endif

  if g:workman_normal_qwerty
    call workman#normal_qwerty()
  endif

  if g:workman_insert_qwerty
    call workman#insert_qwerty()
  endif
endfunc

autocmd VimEnter * call <SID>init()
" Teardown: {{{1
let &cpo = s:save_cpo

" Misc: {{{1
" vim: set ft=vim ts=2 sw=2 tw=78 et fdm=marker:
