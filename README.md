> *repl*

                    _       _              ~
     _ __ ___ _ __ | |_   _(_)_ __ ___     ~
    | '__/ _ \ '_ \| \ \ / / | '_ ` _ \    ~
    | | |  __/ |_) | |\ V /| | | | | | |   ~
    |_|  \___| .__/|_(_)_/ |_|_| |_| |_|   ~
             |_|                           ~

- Launching REPL from (Neo)VIM.
- Author: Arthur Lui
- Date: 11 March 2023
- Repo: https://github.com/luiarthur/repl.vim

### Dependencies
> *repl-dependencies*

- NeoVIM >= 0.5 or VIM >= 8.2

### Installation
> *repl-installation*

If using the `plug.vim` plugin manager, add `Plug luiarthur/repl.vim` to the
correct location. Similar for other vim plugin managers. If not using a plugin
manager, just copy `plugin/repl.vim` to `~/.vim/plugin/` (for vim users). If
using NeoVIM, a plugin manager is recommended.

### Usage
> *repl-usage*

1. Open a file in (Neo)VIM.
2. In `Normal` mode, type `Ctrl-k`. If the file extension is of a supported
   language (see below), then an appropriate REPL will be spawned in a separate
   buffer in the lower region of the current tab.
3. Navigation (see below)

### Navigation
> *repl-nav*

From a (Neo)VIM buffer (file), you can do the following in `Normal` mode.

Action                                   | Command
---------------------------------------- |--------------------------------------------------
Start REPL (see above)                   | `Ctrl-k`
Source the file (language is supported)  | `Ctrl-h` anywhere in file
Send current line to REPL below          | `Ctrl-j` on a line
Send current line to REPL on right       | `Ctrl-l` on a line
Send the selected lines to REPL below    | `Ctrl-j` on a visual selection of multiple lines 
Send the selected lines to REPL on right | `Ctrl-l` on a visual selection of multiple lines 

Note that the REPL (and buffers) will be in `Normal` mode, but lines from the
buffer will be executed in the REPLs.

The default key-bindings can be remapped. For example, the default bindings are
defined as follows:

Action                                   | Default key-binding
---------------------------------------- |------------------------------------------
Start REPL                               | `nmap <C-k> <Plug>ReplStartTermBelow<CR>`
Source the file                          | `nmap <C-h> <Plug>ReplSourceFile<CR>`
Send current line to REPL below          | `nmap <C-j> <Plug>ReplSendDown<CR>`
Send current line to REPL on right       | `nmap <C-l> <Plug>ReplSendRight<CR>`
Send the selected lines to REPL below    | `xmap <C-j> <Plug>ReplSendDownV`
Send the selected lines to REPL on right | `xmap <C-l> <Plug>ReplSendRightV`

Default key bindings will be used if either `let g:repl_default_key_bindings = 1`
is defined in `init.vim`/`vimrc` (NeoVIM/VIM) OR `g:repl_default_key_bindings`
is not defined.

### Supported Languages
> *repl-languages*

- Julia (`*.jl`)
- Python (`*.py`)
- R (`*.R`)

### About
> *repl-about*

Inspired by `https://github.com/karoliskoncevicius/vim-sendtowindow`.

