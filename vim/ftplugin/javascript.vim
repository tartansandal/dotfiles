"use js-beautify for indentation
" setlocal equalprg=js-beautify\ --stdin

" Use Coc to reformat instead of ALEFix
vmap <buffer> <leader>f  <Plug>(coc-format-selected)
nmap <buffer> <leader>f  <Plug>(coc-format-selected)

setlocal shiftwidth=2
