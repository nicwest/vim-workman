[![Build Status](https://travis-ci.org/nicwest/vim-workman.svg)](https://travis-ci.org/nicwest/vim-workman)
vim-workman
===========

Vim bindings for the [workman keyboard layout][workman]. Brings sanity to
workman normal mode or use workman in insert mode on a qwerty layout.

langmap with function keys!


Commands
--------

```vim
Workman       "maps a qwerty layout keyboard to workmap in insert mode 
Workman!      "maps a qwerty layout keyboard to workmap in normal mode (why?!?)

Qwerty        "maps a workman layout keyboard to qwerty in insert mode 
Qwerty!       "maps a workman layout keyboard to qwerty in normal mode 

WorkmanUndo   "Undoes bindings from the other commands (both insert & normal)
```

Settings
--------

These go in your .vimrc or similar so you don't have to use the commands all the
time. They are all off by default.

```vim
g:workman_normal_workman = 0
g:workman_insert_workman = 0
g:workman_normal_qwerty = 0
g:workman_insert_qwerty = 0
```

Tests
-----

Tests are written for [vim-themis][vim-themis]    
To run tests, clone vim-themis, and simply run the tests:

```
git clone https://github.com/thinca/vim-themis.git 
vim-themis/bin/themis --reporter dot test
```

Notes
-----

this plugin was originally this gist [MattWoelk/887861][gist] which was in turn
this script [colquer][colquer]


[workman]: https://github.com/ojbucao/Workman
[vim-themis]: https://github.com/thinca/vim-themis
[gist]: https://gist.github.com/MattWoelk/887861
[colquer]: http://www.vim.org/scripts/script.php?script_id=2865
