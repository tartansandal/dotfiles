setlocal textwidth=88      " Black Friendly
setlocal foldmethod=indent " PEP-8 Friendly

let b:ale_linters=['flake8']
let b:ale_fixers=['black', 'isort', 'remove_trailing_lines', 'trim_whitespace']
let b:coc_root_patterns = [
            \ '.git', 
            \ '.env', 
            \ 'venv', 
            \ '.venv', 
            \ 'setup.cfg', 
            \ 'setup.py', 
            \ 'pyrightconfig.json'
            \ ]
