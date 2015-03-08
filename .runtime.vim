" Used for local development, with vim-scriptease
let s:path = expand('<sfile>:p:h')
exe 'Runtime!'  s:path . '/plugin/workman.vim'
exe 'Runtime!'  s:path . '/autoload/workman.vim'
