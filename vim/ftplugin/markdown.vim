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
" remark is broken again
let b:ale_linters=[] " 'remark-lint']
let b:ale_fixers=[]  " 'remark-lint']
