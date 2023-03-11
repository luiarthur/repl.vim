" Plugin: repl.vim
" Author: Arthur Lui
" Date: 10 March, 2023
" Dependencies: VIM >= 8.2 / NeoVIM >= 0.5
" OS: Linux, MacOS, Windows
" Resources: `:h registers`, `:h scope`

" Appearance settings.
set ma
set splitbelow
set splitright
set fillchars=stl:-
set fillchars+=stlnc:-

" Return the current operating system.
" Either Windows or Unix (i.e. Mac or Linux).
if has('win64') || has('win32') || has('win16')
  let g:os = 'win'
elseif has('unix')
  let g:os = 'unix'
else
  let g:os = 'other'
end

" Starts a terminal (possibly with a REPL if extension is recognized), below
" the script.
function! s:ReplStartTermBelow()
  " Get file extension
  let ext = expand("%:e")

  " Dictionary of program REPLs, with file extensions as keys.
  let repl_dict = {
    \"R": "R",
    \"jl": "julia",
    \"py": "ipython --no-autoindent"
  \}

  " Default shell for operating system.
  let shell = get({'win': 'powershell', 'unix': 'bash'}, g:os, '')

  " REPL to launch.
  let repl = get(repl_dict, ext, shell)

  if shell == ''
    echo "Could not detect OS! REPL cannot be launched."
    finish
  endif

  if has('nvim')  " using NeoVIM
    " Open terminal below and start REPL.
    exec 'split | terminal ' . repl
  else  " regular VIM >= 8.2
    " Open terminal below and start REPL. t:term_buf_nbr so that the varible
    " is lobal to the tab. This allows separate vim tabs to have their own
    " REPL.
    " See: https://vi.stackexchange.com/questions/25898/variable-vs-global-variable
    let t:term_buf_nbr = term_start(repl, {
      \"term_finish": "close",
      \"vertical": "yes"
    \})
  endif

  " Go to bottom of REPL. This is needed to show the bottom (instead of the
  " top) of the REPL.
  normal! G

  " Send cursor back to previous window.
  wincmd p
endfunction

" Sources a file into console below.
function! s:ReplSourceFile()
  let ext = expand("%:e")
  let filename = expand("%:p")

  " TODO (10 March 2023): Check that the forward slashes are properly escaped
  " in each language.
  let cmd = get({
    \'R': 'source("' . filename . '")',
    \'jl': 'include("' . filename . '")',
    \'py': 'exec(open(r"' . filename . '").read())',
    \'kt': ':load ' . filename,
    \'scala': ':load ' . filename,
  \}, ext, '')

  if cmd == ""
    let lineByLine = confirm(
      \"No kernel for `." . ext . "`. Run line by line?",
      \"&Yes\n&No"
    \)
    if lineByLine == 1
      %call s:ReplSendDown("line")
    endif
  else
    if has('nvim')  " NeoVIM >= 0.5
      wincmd j
      call chansend(b:terminal_job_id, cmd . "\r")
      wincmd p
    else  " regular VIM >= 8.2
      call term_sendkeys(t:term_buf_nbr, cmd . "\n")
    endif
  endif
endfunction

" Send text to another window.
function! s:ReplSendToWindow(type, direction)
  if a:type == "line"
    normal! yy
  else
    keepjumps normal! `<v`>y']
  endif

  let end_char = get({'line': ""}, a:type, "\n")

  if has('nvim')  " NeoVIM >= 0.5
    exec "wincmd " . a:direction
    call chansend(b:terminal_job_id, @" . end_char)
  else  " regular VIM >= 8.2
    call term_sendkeys(t:term_buf_nbr, @" . end_char)
    exec "wincmd " . a:direction
  endif

  normal! G
  wincmd p
endfunction

" Send text the window on the right.
function! s:ReplSendRight(type)
  call s:ReplSendToWindow(a:type, 'l')
endfunction

" Send text the window below.
function! s:ReplSendDown(type)
  call s:ReplSendToWindow(a:type, 'j')
endfunction

" ------------------------ Maps --------------------------------------------
nnoremap <silent> <Plug>ReplStartTermBelow :<C-U> call <SID>ReplStartTermBelow()<CR>
nnoremap <silent> <Plug>ReplSourceFile :<C-U> call <SID>ReplSourceFile()<CR>
nnoremap <silent> <Plug>ReplSendDown :<C-U> call <SID>ReplSendDown('line')<CR>
nnoremap <silent> <Plug>ReplSendRight :<C-U> call <SID>ReplSendRight('line')<CR>
xnoremap <silent> <Plug>ReplSendDownV :<C-U> call <SID>ReplSendDown(visualmode())<CR>
xnoremap <silent> <Plug>ReplSendRightV :<C-U> call <SID>ReplSendRight(visualmode())<CR>

" The following default key bindings will be used if `repl_default_bindings`
" is not defined OR `let g:repl_default_bindings = 1` is set in `init.vim`
" (NeoVIM) or `vimrc` (VIM).
if !exists("g:repl_default_bindings") || g:repl_default_bindings
  nmap <C-k> <Plug>ReplStartTermBelow<CR>
  nmap <C-h> <Plug>ReplSourceFile<CR>
  nmap <C-l> <Plug>ReplSendRight<CR>
  xmap <C-l> <Plug>ReplSendRightV
  nmap <C-j> <Plug>ReplSendDown<CR>
  xmap <C-j> <Plug>ReplSendDownV
endif
