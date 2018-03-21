" Vim colour file --- PSC
" Maintainer:	Kahlil (Kal) Hodgson
" Last Change:	16 Jul 2005
" Version:	1.0
" URL:		http://vim.sourceforge.net/scripts/
"
"    Theme based on PS Color by Pan Shizhu for use with Moonlight 
"    Metacity Theme. Lines containing a comment with the tag
"    moonlight::color are used for the automatic update mechanism --
"    best to leave them alone.

"
" Initializations: {{{1
"
function! s:init_option(var, value)
    if !exists("g:psc_".a:var)
        execute "let s:".a:var." = ".a:value
    else
        let s:{a:var} = g:psc_{a:var}
    endif
endfunction
command! -nargs=+ InitOpt call s:init_option(<f-args>)

function! s:multi_hi(setting, ...)
    let l:idx = a:0
    while l:idx > 0
        let l:hlgroup = a:{l:idx}
        execute "highlight ".l:hlgroup." ".a:setting
        let l:idx = l:idx - 1
    endwhile
endfunction
command! -nargs=+ MultiHi call s:multi_hi(<f-args>)

"" force cool,plain,default,dark as the only sensible options with Moonlight
InitOpt inversed_todo 0
InitOpt statement_different_from_type 1
InitOpt other_style 0
set background=dark

highlight clear

if exists("syntax_on")
    syntax reset
endif

let s:color_name = expand("<sfile>:t:r")

if s:other_style==0 | let g:colors_name = s:color_name
    " Go from console version to gui, the color scheme should be sourced again
    execute "autocmd TermChanged * if g:colors_name == '".s:color_name."' | "
                \."colo ".s:color_name." | endif"
else
    execute "runtime colors/midnight.vim"
endif

" }}}1

" Relevant Help: 
" :h highlight-groups
" :h psc-cterm-color-table
" :ru syntax/hitest.vim
"
" Hardcoded Colors Comment:
" #aabbcc = Red aa, Green bb, Blue cc
" we must use hard-coded colours to get more 'tender' colours
"

" GUI:
" 
if has('gui_running')
    highlight Visual		guibg=#D9D9D9  " moonlight::grey85
    highlight Visual		guifg=#262626  " moonlight::grey25
    highlight Comment		guibg=bg
    highlight Comment		guifg=#D0D090  " moonlight::yellow 
    highlight Constant		guibg=bg
    highlight Constant		guifg=#80C0E0  " moonlight::blue 
    highlight FoldColumn	guibg=#4C4C4C  " moonlight::grey30
    highlight FoldColumn	guifg=#e0e0e0  
    highlight Folded		guibg=#404040  " moonlight::grey25 
    highlight Folded		guifg=#D9D9D9  " moonlight::grey85 
    highlight IncSearch		guibg=#737373  " moonlight::grey45
    highlight IncSearch		guifg=#E6E6E6  " moonlight::grey90
    highlight Normal		guibg=#000000  " moonlight::black
    highlight Normal		guifg=#CCCCCC  " moonlight::grey80  
    highlight StatusLine	guibg=#A6A6A6  " moonlight::grey65
    highlight StatusLine	guifg=#000000  
    highlight StatusLineNC	guibg=#8C8C8C  " moonlight::grey55
    highlight StatusLineNC	guifg=#000000  
    highlight SpellErrors   guibg=#E0785A  " moonlight::orange
    highlight SpellErrors   guifg=#000000
    highlight Search		guifg=#E0785A  " moonlight::orange
    highlight Search		guibg=#262626  " moonlight::grey15

    highlight Cursor		guibg=#00f000
    highlight Cursor		guifg=#000000  
    " highlight CursorIM	    guifg=#000000 " don't know what this does

    highlight DiffAdd		guibg=#000080
    highlight DiffAdd		guifg=fg	   
    highlight DiffChange	guibg=#800080
    
    highlight DiffDelete	guibg=#202020
    highlight DiffDelete	guifg=#6080f0  
    highlight DiffText		guibg=#c0e080
    highlight DiffText		guifg=#000000  
    highlight Directory		guibg=bg
    highlight Directory		guifg=#80c0e0  
    highlight Error		    guibg=bg
    highlight Error		    guifg=#f08060  
    highlight ErrorMsg		guibg=#800000
    highlight ErrorMsg		guifg=#d0d090  
    highlight Identifier	guibg=bg
    highlight Identifier	guifg=#f0c0f0  
    highlight Ignore		guibg=bg
    highlight Ignore		guifg=#000000  
    highlight LineNr		guibg=bg
    highlight LineNr		guifg=#b0b0b0  
    highlight ModeMsg		guibg=#000080
    highlight ModeMsg		guifg=fg	   
    highlight MoreMsg		guibg=bg
    highlight MoreMsg		guifg=#c0e080  
    " highlight NonText		guibg=#101010
    " highlight NonText		guifg=#6080f0 " contrast either none or 10% 
    highlight Number		guibg=bg
    highlight Number		guifg=#e0c060  
    highlight PreProc		guibg=bg
    highlight PreProc		guifg=#60f080  
    highlight Question		guibg=#d0d080
    highlight Question		guifg=#000000  
    highlight SignColumn	guibg=#008000
    highlight SignColumn	guifg=#e0e0e0  
    highlight Special		guibg=bg
    highlight Special		guifg=#e0c060  
    highlight SpecialKey	guibg=bg
    highlight SpecialKey	guifg=#b0d0f0  
    highlight Statement		guibg=bg
    highlight Statement		guifg=#98a8f0  

    highlight Title		    guibg=bg
    highlight Title		    guifg=#f0c0f0  
    highlight Todo		    guibg=#680068
    highlight Todo		    guifg=#d0d0d0  
    highlight Type		    guibg=bg
    highlight Type		    guifg=#b0d0f0  
    highlight Underlined	gui=underline 
    highlight Underlined	guibg=bg
    highlight Underlined	guifg=#80a0ff
    highlight VertSplit		guibg=#a0a0a0
    highlight VertSplit		guifg=#000000  
    highlight VisualNOS		guibg=#000080
    highlight VisualNOS		guifg=fg	   
    highlight WarningMsg	guibg=bg
    highlight WarningMsg	guifg=#f08060  
    highlight WildMenu		guibg=#d0d090
    highlight WildMenu		guifg=#000000  
    highlight Pmenu		guibg=#d0d090
    highlight Pmenu		guifg=#000000  
    highlight PmenuSel	guifg=#000000
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
MultiHi gui=NONE ModeMsg Search Cursor Special Comment Constant Number LineNr Question PreProc Statement Type Todo Error Identifier Normal

MultiHi gui=NONE VisualNOS SpecialKey NonText Directory ErrorMsg MoreMsg Title WarningMsg WildMenu Folded FoldColumn DiffAdd DiffChange DiffDelete DiffText SignColumn

" For reversed stuffs
MultiHi gui=NONE IncSearch StatusLine StatusLineNC VertSplit Visual

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
    highlight Normal	    ctermfg=LightGrey   ctermbg=Black
    highlight Search	    ctermfg=White	    ctermbg=DarkRed
    highlight Visual	    ctermfg=Black	    ctermbg=DarkGrey
    highlight Cursor	    ctermfg=Black	    ctermbg=Green
    highlight CursorIM	    ctermfg=Black	    ctermbg=Green
    highlight Special	    ctermfg=Yellow	    ctermbg=Black
    highlight Comment	    ctermfg=DarkYellow  ctermbg=Black
    highlight Constant	    ctermfg=Blue	    ctermbg=Black
    highlight Number	    ctermfg=Yellow	    ctermbg=Black
    "" make focused unfocused the same as colors are otherwise too bright
    "" perhaps change the color definitions
    highlight StatusLine    ctermfg=Black	    ctermbg=Darkgrey
    " foreground/background sense is reversed
    highlight StatusLineNC  ctermbg=Black	    ctermfg=DarkGrey
    highlight LineNr	    ctermfg=DarkGrey    ctermbg=Black
    highlight Question	    ctermfg=Black	    ctermbg=DarkYellow
    highlight PreProc	    ctermfg=Green	    ctermbg=Black
    highlight Statement	    ctermfg=Cyan	    ctermbg=Black
    highlight Type	        ctermfg=Cyan	    ctermbg=Black
    highlight Todo	        ctermfg=DarkRed     ctermbg=DarkYellow
    "highlight Todo	 cter   mfg=DarkYellow ctermbg=DarkBlue
    highlight Error	        ctermfg=Red	        ctermbg=Black
    highlight Identifier    ctermfg=Magenta     ctermbg=Black
    highlight Folded	    ctermfg=White	    ctermbg=DarkGreen
    highlight ModeMsg	    ctermfg=Grey	    ctermbg=DarkBlue
    highlight VisualNOS	    ctermfg=Grey	    ctermbg=DarkBlue
    highlight SpecialKey    ctermfg=Cyan	    ctermbg=Black
    highlight NonText	    ctermfg=Blue	    ctermbg=Black
    highlight Directory	    ctermfg=Blue	    ctermbg=Black
    highlight ErrorMsg	    ctermfg=DarkYellow  ctermbg=DarkRed
    highlight MoreMsg	    ctermfg=Green	    ctermbg=Black
    highlight Title	        ctermfg=Magenta     ctermbg=Black
    highlight WarningMsg    ctermfg=Red	        ctermbg=Black
    highlight WildMenu	    ctermfg=Black	    ctermbg=DarkYellow
    highlight FoldColumn    ctermfg=White	    ctermbg=DarkGreen
    highlight SignColumn    ctermfg=White	    ctermbg=DarkGreen
    highlight DiffText	    ctermfg=Black	    ctermbg=DarkYellow
    highlight DiffDelete    ctermfg=Blue	    ctermbg=Black

    if &t_Co==8
        " 8 colour terminal support, this assumes 16 colour is available through
        " setting the 'bold' attribute, will get bright foreground colour.
        " However, the bright background color is not available for 8-color terms.
        "
        " You can manually set t_Co=16 in your .vimrc to see if your terminal
        " supports 16 colours, 
        MultiHi cterm=none DiffText Visual Cursor Comment Todo StatusLine Question DiffChange ModeMsg VisualNOS ErrorMsg WildMenu DiffAdd Folded DiffDelete Normal
        MultiHi cterm=bold Search Special Constant Number LineNr PreProc Statement Type Error Identifier SpecialKey NonText MoreMsg Title WarningMsg FoldColumn SignColumn Directory DiffDelete

    else
        " Background > 7 is only available with 16 or more colors
        " bold is not an option
        MultiHi cterm=none WarningMsg Search Visual Cursor Special Comment Constant Number LineNr PreProc Todo Error Identifier Folded SpecialKey Directory ErrorMsg Normal
        MultiHi cterm=none WildMenu FoldColumn SignColumn DiffAdd DiffChange Question StatusLine DiffText
        MultiHi cterm=reverse IncSearch StatusLineNC VertSplit

        " Well, well, bold font with color 0-7 is not possible.
        " So, the Question, StatusLine, DiffText cannot act as expected.

        call s:multi_hi("cterm=none", "Statement", "Type", "MoreMsg", "ModeMsg", "NonText", "Title", "VisualNOS", "DiffDelete")

    endif
endif
" }}}1


" Term:
" For console with only 4 colours (term, not cterm), we'll use the default.
" ...
" The default colorscheme is good enough for terms with no more than 4 colours
"


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

" COLOR LINKS DEFINE END

" Clean:
"
delcommand InitOpt
delcommand MultiHi

" vim:et:nosta:sw=4:ts=4:
" vim600:fdm=marker:fdl=1:
