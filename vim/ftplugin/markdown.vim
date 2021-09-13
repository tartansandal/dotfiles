" less indentation for markdown files
" helps with errors from mdl

setlocal tabstop=2
setlocal shiftwidth=2
set formatoptions-=t    " dont auto-wrap text using textwidth
set columns=83          " so we get soft wrapping effect

" Map \` to suround the inner WORD with ` marks
nmap <buffer> <leader>` ysiW`

nmap <buffer> <silent> <leader>tt :call checkbox#ToggleCB()<cr>
nmap <buffer> <silent> <leader>te  :NewTimeLogEntry<cr>
imap <buffer> <silent> <leader>tt <Esc>:call checkbox#ToggleCB()<cr>
imap <buffer> <silent> <leader>te <Esc>:NewTimeLogEntry<cr>
"
" > Linting
"let b:ale_linters=['mdl', 'remark-lint']
let b:ale_linters=['remark-lint']
let b:ale_markdown_mdl_options='--style ~/.mdl-style.rb'

let b:ale_fixers=['remark-lint', 'remove_trailing_lines', 'trim_whitespace']
