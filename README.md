![GitHub Workflow Status](https://img.shields.io/github/workflow/status/nicwest/vim-workman/test)
vim-workman
===========

Vim bindings for the [workman keyboard layout][workman]. Brings sanity to
workman normal mode or use workman in insert mode on a qwerty layout.

langmap with function keys!

**still a work in progress, so will probably break alot**

**Note:** normal mode maps require the `langnoremap` setting introduced in
7.4.502, otherwise sanity doesn't really happen much.

Commands
--------

```vim
Workman       "maps a qwerty layout keyboard to workman in insert mode 
Workman!      "maps a qwerty layout keyboard to workman in normal mode

Qwerty        "maps a workman layout keyboard to qwerty in insert mode 
Qwerty!       "maps a workman layout keyboard to qwerty in normal mode 

WorkmanUndo   "Undoes bindings from the other commands (both insert & normal)
```

Settings
--------

These go in your .vimrc or similar so you don't have to use the commands all the
time. They are all off by default. Set to 0 to disable or 1 to enable.

```vim
let g:workman_normal_workman = 0
let g:workman_insert_workman = 0
let g:workman_normal_qwerty = 0
let g:workman_insert_qwerty = 0
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
