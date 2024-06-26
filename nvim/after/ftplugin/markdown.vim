setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2

" Emulate soft-wrapping common in other editors
setlocal linebreak        " Wrap long lines at word boundaries
setlocal formatoptions-=t " dont auto-wrap text using textwidth

" Add '-' to keywords so we can search for references quickly
setlocal iskeyword+=-
