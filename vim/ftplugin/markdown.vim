" less indentation for markdown files
" helps with errors from mdl

setlocal tabstop=2
setlocal shiftwidth=2

" Map \` to suround the inner WORD with ` marks
nmap <buffer> <leader>` ysiW`

nmap <buffer> <silent> <leader>tt :call checkbox#ToggleCB()<cr>
nmap <buffer> <silent> <leader>e  :NewTimeLogEntry<cr>
