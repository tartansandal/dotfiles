" Template Toolkit coinfiguration

au BufNewFile,BufRead *.tt  setf tt2html
au BufNewFile,BufRead *.tt2 setf tt2html

" au BufNewFile,BufRead *.tt2
"         \ if ( getline(1) . getline(2) . getline(3) =~ '<\chtml'
"         \           && getline(1) . getline(2) . getline(3) !~ '<[%?]' )
"         \   || getline(1) =~ '<!DOCTYPE HTML' |
"         \   setf tt2html |
"         \ else |
"         \   setf tt2 |
"         \ endif
" 
" au BufNewFile,BufRead */implementation/htdocs/*     setf tt2html
