setlocal tabstop=2
setlocal shiftwidth=2

" Emulate soft-wrapping common in other editors
setlocal linebreak        " Wrap long lines at word boundaries
setlocal formatoptions-=t " dont auto-wrap text using textwidth
setlocal columns=87       " Constrain window width to trigger soft wrap
"" ^ 85 = 80 for the text width 
"        + 4 for the number column
"        + 2 for the error column
"        + 1 for the marker column

" Add '-' to keywords so we can search for references quickly
setlocal iskeyword+=-

" Map \` to suround the inner WORD with ` marks
nmap <buffer> <leader>` ysiW`

" Map \> to suround the inner URL with <> marks
nmap <buffer> <leader>> ysiu>

" > Linting
let b:ale_linters=['remark-lint']
let b:ale_fixers=['remark-lint']

" For time tracking DIARY
nmap <buffer> <silent> <leader>tt :call checkbox#ToggleCB()<cr>
nmap <buffer> <silent> <leader>te  :NewTimeLogEntry<cr>
imap <buffer> <silent> <leader>tt <Esc>:call checkbox#ToggleCB()<cr>
imap <buffer> <silent> <leader>te <Esc>:NewTimeLogEntry<cr>
