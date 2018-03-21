" Vim colour file --- PSC
" Maintainer:	Kahlil (Kal) Hodgson
" Last Change:	16 Jul 2005
" Version:	1.0
" URL:		http://vim.sourceforge.net/scripts/
"
"    Theme based on PS Color by Pan Shizhu for use with 

set background=light
highlight clear

if exists("syntax_on")
    syntax reset
endif

" }}}1

" Hardcoded Colors Comment:
" #aabbcc = Red aa, Green bb, Blue cc
" we must use hard-coded colours to get more 'tender' colours


" GUI:
" 
if has('gui_running')

    hi Normal     guifg=#000000  guibg=#e0e0e0

    hi Red      guifg=#840000
    hi Green    guifg=#007300  gui=none
    hi Blue     guifg=#000084
    hi Brown    guifg=#755B00  gui=none
    hi Cyan     guifg=#007373  gui=none
    hi Magenta	guifg=#730073

    hi Violet	guifg=#732773
    hi Yellow	guifg=#732773

    hi! TabLine guibg=#b2b2b2 guifg=#000000
    " match TabLine /	/

    hi! link Statement  Red
    hi! link Type       Brown
    hi! link Identifier Green
    hi! link PreProc    Cyan    
    hi! link Comment    Blue 
    hi! link Constant   Magenta 
    hi! link SpecialKey Blue
    hi! link NonText    Blue
    hi! link Directory  Blue
    hi! link ErrorMsg   Red
    hi! link MoreMsg    Green
    hi! link LineNr     Brown
    hi! link Question   Green

    hi Title        guifg=#8C4600 gui=underline
    hi Folded		guibg=#AAAAAA  " lightgrey
    hi Visual		guibg=#A0A0A0  " grey35
    hi foldcolumn	guibg=#b8b8b8 
    hi foldcolumn	guifg=#e0e0e0 

    hi! CursorLine  guibg=#F5F5F5

    " fg/bg sense is reversed in these separtors
    hi statusline	guifg=#A0A0A0 
    hi statusline	guibg=fg
    hi statuslinenc	guifg=#8C8C8C
    hi StatusLineNC	guibg=fg
    hi VertSplit	guifg=#A0A0A0  " darker than normal
    hi VertSplit	guibg=fg

    hi Search		guibg=#b8b8b8  " darker than normal
    hi IncSearch	guifg=#b8b8b8  " lighter than normal 
    hi IncSearch	guibg=fg

    hi SpellErrors  guibg=#E0785A
    
    hi Pmenu    guibg=#b8b8b8 guifg=black
    hi PmenuSel guibg=#FFFFFF guifg=black

    highlight Cursor		guibg=#002300
    "highlight Cursor		guifg=#000000  
    "highlight CursorIM	    guifg=#000000 " don't know what this does

    highlight DiffAdd		guibg=LightGreen
    
    highlight DiffChange	guibg=LightBlue
     
    highlight DiffDelete	guibg=LightRed
    
    highlight DiffText		guibg=bg gui=NONE
    
endif


" Links:
"
" COLOR LINKS DEFINE START

highlight link		String		Constant
" Character must be different from strings because in many languages
" (especially C, C++) a 'char' variable is scalar while 'string' is pointer,
" mistaken a 'char' for a 'string' will cause disaster!
highlight link		Character	Number
highlight link		SpecialChar	LineNr
highlight link		Tag		Identifier

" vim:et:nosta:sw=4:ts=4:
" vim600:fdm=marker:fdl=1:
