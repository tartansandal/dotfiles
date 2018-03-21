" Vim colour file --- PSC
" Maintainer:	Kahlil (Kal) Hodgson
" Last Change:	16 Jul 2005
" Version:	1.0
" URL:		http://vim.sourceforge.net/scripts/
"
"    Theme based on PS Color by Pan Shizhu for use with Mooonlight 
"    Metacity Theme. Lines containing a comment with the tag
"    lazylooks::color are used for the automatic update mechanism --
"    best to leave them alone.

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

    " hi Normal     guifg=#000000  guibg=#BABABA
    hi Normal     guifg=#000000  guibg=#B2B2B2
    " hi Normal     guifg=#000000  guibg=#CCCCCC

    hi Red      guifg=#8A0000
    hi Blue     guifg=#000082
    "hi Blue     guifg=#00008C
    hi Brown    guifg=#8C4600  gui=none
    "hi Green    guifg=#006600  gui=none
    hi Green    guifg=#006600  gui=none
    hi Cyan     guifg=#006666  gui=underline
    "hi Magenta	guifg=#80007F
    hi Magenta	guifg=#730073

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
    hi foldcolumn	guibg=#4c4c4c 
    hi foldcolumn	guifg=#e0e0e0 

    " fg/bg sense is reversed in these separtors
    hi statusline	guifg=#A0A0A0 
    hi statusline	guibg=fg
    hi statuslinenc	guifg=#8C8C8C
    hi StatusLineNC	guibg=fg
    hi VertSplit	guifg=#A0A0A0  " darker than normal
    hi VertSplit	guibg=fg
    hi IncSearch	guifg=#DDDDDD  " lighter than normal 
    hi IncSearch	guibg=fg

    hi SpellErrors  guibg=#E0785A
    hi Search		guibg=#B0B0B0  " darker than normal
    
    hi Pmenu     guifg=Black guibg=#AAAAAA
    hi PmenuSel  guifg=Black guibg=#80007F guifg=#FAFAFA



    """ MiniBufExplorer
    " buffers that have NOT CHANGED and are NOT VISIBLE.
    hi! link MBENormal   Normal
    " buffers that HAVE CHANGED and are NOT VISIBLE
    hi! link MBEChanged  Green
    " buffers that have NOT CHANGED and are VISIBLE
    hi! link MBEVisibleNormal Magenta 
    " buffers that have CHANGED and are VISIBLE
    hi! link MBEVisibleChanged Red

    " highlight Cursor		guibg=#00f000
    " highlight Cursor		guifg=#000000  
    " " highlight CursorIM	    guifg=#000000 " don't know what this does

    " highlight DiffAdd		guibg=#000080
    " highlight DiffAdd		guifg=fg	   
    " highlight DiffChange	guibg=#800080
    " 
    " highlight DiffDelete	guibg=#202020
    " highlight DiffDelete	guifg=#6080f0  
    " highlight DiffText		guibg=#c0e080
    " highlight DiffText		guifg=#000000  
    " highlight Directory		guibg=bg
    " highlight Directory		guifg=#80c0e0  
    " highlight Error		    guibg=bg
    " highlight Error		    guifg=#f08060  
    " highlight ErrorMsg		guibg=#800000
    " highlight ErrorMsg		guifg=#d0d090  
    " highlight Identifier	guibg=bg
    " highlight Identifier	guifg=#f0c0f0  
    " highlight Ignore		guibg=bg
    " highlight Ignore		guifg=#000000  
    " highlight LineNr		guibg=bg
    " highlight LineNr		guifg=#b0b0b0  
    " highlight ModeMsg		guibg=#000080
    " highlight ModeMsg		guifg=fg	   
    " highlight MoreMsg		guibg=bg
    " highlight MoreMsg		guifg=#c0e080  
    " " highlight NonText		guibg=#101010
    " " highlight NonText		guifg=#6080f0 " contrast either none or 10% 
    " highlight Number		guibg=bg
    " highlight Number		guifg=#e0c060  
    " highlight PreProc		guibg=bg
    " highlight PreProc		guifg=#60f080  
    " highlight Question		guibg=#d0d080
    " highlight Question		guifg=#000000  
    " highlight SignColumn	guibg=#008000
    " highlight SignColumn	guifg=#e0e0e0  
    " highlight Special		guibg=bg
    " highlight Special		guifg=#e0c060  
    " highlight SpecialKey	guibg=bg
    " highlight SpecialKey	guifg=#b0d0f0  
    " highlight Statement		guibg=bg
    " highlight Statement		guifg=#98a8f0  

    " highlight Todo		    guibg=#680068
    " highlight Todo		    guifg=#d0d0d0  
    " highlight Type		    guibg=bg
    " highlight Type		    guifg=#b0d0f0  
    " highlight Underlined	gui=underline 
    " highlight Underlined	guibg=bg
    " highlight Underlined	guifg=#80a0ff
    " highlight VertSplit		guibg=#a0a0a0
    " highlight VertSplit		guifg=#000000  
    " highlight VisualNOS		guibg=#000080
    " highlight VisualNOS		guifg=fg	   
    " highlight WarningMsg	guibg=bg
    " highlight WarningMsg	guifg=#f08060  
    " highlight WildMenu		guibg=#d0d090
    " highlight WildMenu		guifg=#000000  
endif

" Take NT gui for example, If you want to use a console font such as
" Lucida_Console with font size larger than 14, the font looks already thick,
" and the bold font for that will be too thick, you may not want it be bolded.
" The following code does this.
"
" All of the bold font may be disabled, since continuously switching between
" bold and plain font hurts consistency and will inevitably fatigue your eye!

" Maximum 20 parameters for vim script function
"

" hi StatusLine gui=bold,reverse

" Color Term: {{{1

" It's not quite possible to support 'cool' and 'warm' simultaneously, since
" we cannot expect a terminal to have more than 16 color names. 
"
" Heres's a guide to the color values
"
"	Color name	    Hex value	Decimal value 
"	 0 Black	    = #000000	0,0,0
"	 4 DarkBlue	    = #000080	0,0,128
"	 2 DarkGreen	= #008000	0,128,0
"	 6 DarkCyan	    = #a6caf0	166,202,240
"	 1 DarkRed	    = #800000	128,0,0
"	 5 DarkMagenta	= #800080	128,0,128
"	 3 DarkYellow	= #d0d090	208,208,144
"	 7 Grey		    = #d0d0d0	208,208,208
"	 8 DarkGrey	    = #b0b0b0	176,176,176
"	12 Blue		    = #80c0e0	128,192,224
"	10 Green	    = #60f080	96,240,128
"	14 Cyan		    = #c0d8f8	192,216,248
"	 9 Red		    = #f08060	240,128,96
"	13 LMag.	    = #f0c0f0	240,192,240
"	11 Yellow	    = #e0c060	224,192,96
"	15 White	    = #e0e0e0	224,224,224
" 
" I assume Vim will never go to cterm mode when has("gui_running") returns 1,
" Please enlighten me if I am wrong.
"
if !has('gui_running')
    hi Pmenu     ctermfg=Black ctermbg=Grey
    hi PmenuSel  ctermfg=Black ctermbg=Magenta
    " use defaults
"    highlight Normal	    ctermfg=LightGrey   ctermbg=Black
"    highlight Search	    ctermfg=White	    ctermbg=DarkRed
"    highlight Visual	    ctermfg=Black	    ctermbg=DarkGrey
"    highlight Cursor	    ctermfg=Black	    ctermbg=Green
"    highlight CursorIM	    ctermfg=Black	    ctermbg=Green
"    highlight Special	    ctermfg=Yellow	    ctermbg=Black
"    highlight Comment	    ctermfg=DarkYellow  ctermbg=Black
"    highlight Constant	    ctermfg=Blue	    ctermbg=Black
"    highlight Number	    ctermfg=Yellow	    ctermbg=Black
"    "" make focused unfocused the same as colors are otherwise too bright
"    "" perhaps change the color definitions
"    highlight StatusLine    ctermfg=Black	    ctermbg=Darkgrey
"    " foreground/background sense is reversed
"    highlight StatusLineNC  ctermbg=Black	    ctermfg=DarkGrey
"    highlight LineNr	    ctermfg=DarkGrey    ctermbg=Black
"    highlight Question	    ctermfg=Black	    ctermbg=DarkYellow
"    highlight PreProc	    ctermfg=Green	    ctermbg=Black
"    highlight Statement	    ctermfg=Cyan	    ctermbg=Black
"    highlight Type	        ctermfg=Cyan	    ctermbg=Black
"    highlight Todo	        ctermfg=DarkRed     ctermbg=DarkYellow
"    "highlight Todo	 cter   mfg=DarkYellow ctermbg=DarkBlue
"    highlight Error	        ctermfg=Red	        ctermbg=Black
"    highlight Identifier    ctermfg=Magenta     ctermbg=Black
"    highlight Folded	    ctermfg=White	    ctermbg=DarkGreen
"    highlight ModeMsg	    ctermfg=Grey	    ctermbg=DarkBlue
"    highlight VisualNOS	    ctermfg=Grey	    ctermbg=DarkBlue
"    highlight SpecialKey    ctermfg=Cyan	    ctermbg=Black
"    highlight NonText	    ctermfg=Blue	    ctermbg=Black
"    highlight Directory	    ctermfg=Blue	    ctermbg=Black
"    highlight ErrorMsg	    ctermfg=DarkYellow  ctermbg=DarkRed
"    highlight MoreMsg	    ctermfg=Green	    ctermbg=Black
"    highlight Title	        ctermfg=Magenta     ctermbg=Black
"    highlight WarningMsg    ctermfg=Red	        ctermbg=Black
"    highlight WildMenu	    ctermfg=Black	    ctermbg=DarkYellow
"    highlight FoldColumn    ctermfg=White	    ctermbg=DarkGreen
"    highlight SignColumn    ctermfg=White	    ctermbg=DarkGreen
"    highlight DiffText	    ctermfg=Black	    ctermbg=DarkYellow
"    highlight DiffDelete    ctermfg=Blue	    ctermbg=Black
"
endif
" }}}1
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
" The following are not standard hi links, 
" these are used by DrChip
highlight link		Warning		MoreMsg
highlight link		Notice		Constant
" these are used by Calendar
highlight link		CalToday	PreProc
" these are used by TagList
highlight link		MyTagListTagName	IncSearch
highlight link		MyTagListTagScope	Constant

" vim:et:nosta:sw=4:ts=4:
" vim600:fdm=marker:fdl=1:
