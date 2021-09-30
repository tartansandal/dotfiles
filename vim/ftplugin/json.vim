" This helps with Coc configuration files
" which are the extended jsonc
setlocal tabstop=2
setlocal shiftwidth=2
syntax match Comment +\/\/.\+$+

let b:ale_fixers=['fixjson']
let b:ale_linters=['jsonlint']
