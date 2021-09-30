setlocal tabstop=2
setlocal shiftwidth=2
setlocal formatoptions-=t    " dont auto-wrap text using textwidth
setlocal columns=83          " so we get soft wrapping effect

" Add '-' to keywords so we can search for references quickly
setlocal iskeyword+=-

" Map \` to suround the inner WORD with ` marks
nmap <buffer> <leader>` ysiW`

nmap <buffer> <silent> <leader>tt :call checkbox#ToggleCB()<cr>
nmap <buffer> <silent> <leader>te  :NewTimeLogEntry<cr>
imap <buffer> <silent> <leader>tt <Esc>:call checkbox#ToggleCB()<cr>
imap <buffer> <silent> <leader>te <Esc>:NewTimeLogEntry<cr>
"
" > Linting
let b:ale_linters=['remark-lint']
let b:ale_fixers=['remark-lint']
