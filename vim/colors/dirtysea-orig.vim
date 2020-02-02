" Vim color file --- dirtysea
" Maintainer:
" URL:
" Last Change:
" Version:
"
"	The peaksea color is simply a colorscheme with the default settings of
"	the original ps_color. Lite version means there's no custom settings
"	and fancy features such as integration with reloaded.vim
"
"	The full version of ps_color.vim will be maintained until Vim 8.
"	By then there will be only the lite version: peaksea.vim
"
" Note: Please set the background option in your .vimrc and/or .gvimrc
"
"	It is much better *not* to set 'background' option inside
"	a colorscheme file.  because ":set background" improperly
"	may cause colorscheme be sourced twice
"
" Color Scheme Overview:
"	:ru syntax/hitest.vim
"
" Relevant Help:
"	:h highlight-groups
"	:h psc-cterm-color-table
"
" Colors Order:
"	#rrggbb
"

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = expand("<sfile>:t:r")

" LIGHT COLOR DEFINE START

hi Normal		guifg=#000000	guibg=#e0e0e0	gui=NONE
hi Visual		guifg=NONE	guibg=#a6caf0	gui=NONE

hi Cursor		guifg=#f0f0f0	guibg=#008000	gui=NONE
hi CursorIM		guifg=#f0f0f0	guibg=#800080   gui=NONE

" 03
hi Comment		guifg=#000084	guibg=NONE	gui=NONE
hi Folded		guifg=NONE	guibg=#c4d9c4	gui=NONE
hi MatchParen	        guifg=NONE	guibg=#c0e080
hi SpecialKey		guifg=#1050a0	guibg=NONE	gui=NONE
hi NonText		guifg=#002090	guibg=#d0d0d0	gui=NONE
hi StatusLineNC	        guifg=fg	guibg=#c0c0c0	gui=NONE

" 04
hi StatusLine		guifg=fg	guibg=#a8c1dd	gui=NONE


" 08
hi Identifier		guifg=#007300	guibg=NONE	gui=NONE
hi VisualNOS		guifg=fg	guibg=#b0b0e0	gui=NONE
hi ErrorMsg		guifg=fg	guibg=#f0b090	gui=NONE
hi Statement		guifg=#840000	guibg=NONE	gui=NONE
hi DiffDelete		guifg=#002090	guibg=#d0d0d0	gui=NONE

" 09
hi Number		guifg=#730073	guibg=NONE	gui=NONE
hi Constant		guifg=#730073	guibg=NONE	gui=NONE

" 0A
hi Search		guifg=NONE	guibg=#f8f8f8	gui=NONE
hi WildMenu		guifg=fg	guibg=#d0d090	gui=NONE
hi Type		        guifg=#755B00	guibg=NONE	gui=NONE
hi Todo		        guifg=#800000	guibg=#e0e090	gui=NONE
hi PreProc		guifg=#006565	guibg=NONE	gui=NONE

" 0B ?
hi DiffAdd		guifg=NONE	guibg=#b0b0e0	gui=NONE

" 0C ?
hi FoldColumn		guifg=fg	guibg=#90e090	gui=NONE
hi Special		guifg=DarkSlateBlue	guibg=NONE	gui=NONE

" 0D
"" clashes with 03
hi Directory		guifg=#000084	guibg=NONE	gui=NONE

"" clashes with 09
hi Title		guifg=#730073	guibg=NONE	gui=NONE

" 0E
" Nothing

" 0F


hi LineNr		guifg=#686868	guibg=NONE	gui=NONE

hi Question		guifg=fg	guibg=#d0d090	gui=NONE

" NOTE THIS IS IN THE WARM SECTION
hi Error		guifg=#c03000	guibg=NONE	gui=NONE

hi ModeMsg		guifg=fg	guibg=#b0b0e0	gui=NONE



hi MoreMsg		guifg=#489000	guibg=NONE	gui=NONE
hi WarningMsg		guifg=#b02000	guibg=NONE	gui=NONE

hi DiffChange		guifg=NONE	guibg=#e0b0e0	gui=NONE


hi DiffText		guifg=NONE	guibg=#c0e080	gui=NONE
hi SignColumn		guifg=fg	guibg=#C4D9C4	gui=NONE

hi IncSearch		guifg=#f0f0f0	guibg=#806060	gui=NONE
hi VertSplit		guifg=fg	guibg=#c0c0c0	gui=NONE

"08
hi Underlined		guifg=#6a5acd	guibg=NONE	gui=underline
hi Ignore		guifg=bg	guibg=NONE
" NOTE THIS IS IN THE WARM SECTION
if v:version >= 700
  if has('spell')
    hi SpellBad	guifg=NONE	guibg=NONE	guisp=#c03000
    hi SpellCap	guifg=NONE	guibg=NONE	guisp=#162887
    hi SpellRare	guifg=NONE	guibg=NONE	guisp=#6E216E
    hi SpellLocal	guifg=NONE	guibg=NONE	guisp=#007068
  endif
  hi Pmenu		guifg=fg	guibg=#e0b0e0
  hi PmenuSel		guifg=#f0f0f0	guibg=#806060	gui=NONE
  hi PmenuSbar	guifg=fg	guibg=#c0c0c0	gui=NONE
  hi PmenuThumb	guifg=fg	guibg=#c0e080	gui=NONE
  hi TabLine		guifg=fg	guibg=#c0c0c0	gui=NONE
  hi TabLineFill	guifg=fg	guibg=#c0c0c0	gui=NONE
  hi TabLineSel	guifg=fg	guibg=NONE	gui=NONE
  hi CursorColumn	guifg=NONE	guibg=#f0b090
  hi CursorLine	guifg=NONE	guibg=NONE	gui=underline
  hi ColorColumn ctermbg=lightgrey guibg=lightgrey
  hi MatchParen	guifg=NONE	guibg=#c0e080
endif

" LIGHT COLOR DEFINE END

" Vim 7 added stuffs
if v:version >= 700
  hi Ignore		gui=NONE

  " the gui=undercurl guisp could only support in Vim 7
  if has('spell')
    hi SpellBad	gui=undercurl
    hi SpellCap	gui=undercurl
    hi SpellRare	gui=undercurl
    hi SpellLocal	gui=undercurl
  endif
  hi TabLine		gui=underline
  hi TabLineFill	gui=underline
  hi CursorLine	gui=underline
endif

" For reversed stuffs, clear the reversed prop and set the bold prop again
"hi IncSearch		gui=bold
"hi StatusLine		gui=italic
"hi StatusLineNC	gui=italic
"hi VertSplit		gui=bold
"hi Visual		gui=bold

" Enable the bold property
"hi Question		gui=bold
"hi DiffText		gui=bold
"hi Statement		gui=bold
"hi Type		gui=bold
"hi MoreMsg		gui=bold
"hi ModeMsg		gui=bold
"hi NonText		gui=bold
"hi Title		gui=bold
"hi DiffDelete		gui=bold
"hi TabLineSel		gui=bold

" gui define for background=light end here

  " 256color light terminal support here

  hi Normal		ctermfg=16	ctermbg=254	cterm=NONE
  " Comment/Uncomment the following line to disable/enable transparency
  "hi Normal		ctermfg=16	ctermbg=NONE	cterm=NONE
  hi Search		ctermfg=NONE	ctermbg=231	cterm=NONE
  hi Visual		ctermfg=NONE	ctermbg=153	cterm=NONE
  hi Cursor		ctermfg=255	ctermbg=28	cterm=NONE
  hi CursorIM		ctermfg=255	ctermbg=90 cterm=NONE
  hi Special		ctermfg=4	ctermbg=NONE	cterm=NONE
  hi Comment		ctermfg=4	ctermbg=NONE	cterm=NONE
  hi Number		ctermfg=94	ctermbg=NONE	cterm=NONE
  hi Constant		ctermfg=4	ctermbg=NONE	cterm=NONE
  hi StatusLine	        ctermfg=fg	ctermbg=153	cterm=NONE
  hi LineNr		ctermfg=242	ctermbg=NONE	cterm=NONE
  hi Question		ctermfg=fg	ctermbg=186	cterm=NONE
  hi PreProc		ctermfg=5	ctermbg=NONE	cterm=NONE
  hi Statement	ctermfg=1	ctermbg=NONE	cterm=NONE
  hi Type		ctermfg=3	ctermbg=NONE	cterm=NONE
  hi Todo		ctermfg=88	ctermbg=186	cterm=NONE
  " NOTE THIS IS IN THE WARM SECTION
  hi Error		ctermfg=130	ctermbg=NONE	cterm=NONE
  hi Identifier	ctermfg=2	ctermbg=NONE	cterm=NONE
  hi ModeMsg		ctermfg=fg	ctermbg=146	cterm=NONE
  hi VisualNOS	ctermfg=fg	ctermbg=146	cterm=NONE
  hi SpecialKey	ctermfg=25	ctermbg=NONE	cterm=NONE
  hi NonText		ctermfg=18	ctermbg=252	cterm=NONE
  " Comment/Uncomment the following line to disable/enable transparency
  "hi NonText		ctermfg=18	ctermbg=NONE	cterm=NONE
  hi Directory	ctermfg=4	ctermbg=NONE	cterm=NONE
  hi ErrorMsg		ctermfg=fg	ctermbg=216	cterm=NONE
  hi MoreMsg		ctermfg=64	ctermbg=NONE	cterm=NONE
  hi Title		ctermfg=133	ctermbg=NONE	cterm=NONE
  hi WarningMsg	ctermfg=124	ctermbg=NONE	cterm=NONE
  hi WildMenu		ctermfg=fg	ctermbg=186	cterm=NONE
  hi Folded		ctermfg=NONE	ctermbg=151	cterm=NONE
  hi FoldColumn	ctermfg=fg	ctermbg=114	cterm=NONE
  hi DiffAdd		ctermfg=NONE	ctermbg=146	cterm=NONE
  hi DiffChange	ctermfg=NONE	ctermbg=182	cterm=NONE
  hi DiffDelete	ctermfg=18	ctermbg=252	cterm=NONE
  hi DiffText		ctermfg=NONE	ctermbg=150	cterm=NONE
  hi SignColumn	ctermfg=fg	ctermbg=114	cterm=NONE

  hi IncSearch	ctermfg=255	ctermbg=95	cterm=NONE
  hi StatusLineNC	ctermfg=fg	ctermbg=250	cterm=NONE
  hi VertSplit	ctermfg=fg	ctermbg=250	cterm=NONE
  hi Underlined	ctermfg=62	ctermbg=NONE	cterm=underline
  hi Ignore		ctermfg=bg	ctermbg=NONE
  " NOTE THIS IS IN THE WARM SECTION
  if v:version >= 700
    if has('spell')
      if 0
        " ctermsp is not supported in Vim7, we ignore it.
        hi SpellBad	cterm=undercurl	ctermbg=NONE	ctermfg=130
        hi SpellCap	cterm=undercurl	ctermbg=NONE	ctermfg=25
        hi SpellRare	cterm=undercurl	ctermbg=NONE	ctermfg=133
        hi SpellLocal	cterm=undercurl	ctermbg=NONE	ctermfg=23
      else
        hi SpellBad	cterm=undercurl	ctermbg=NONE	ctermfg=NONE
        hi SpellCap	cterm=undercurl	ctermbg=NONE	ctermfg=NONE
        hi SpellRare	cterm=undercurl	ctermbg=NONE	ctermfg=NONE
        hi SpellLocal	cterm=undercurl	ctermbg=NONE	ctermfg=NONE
      endif
    endif
    hi Pmenu		ctermfg=fg	ctermbg=182
    hi PmenuSel	ctermfg=255	ctermbg=95	cterm=NONE
    hi PmenuSbar	ctermfg=fg	ctermbg=250	cterm=NONE
    hi PmenuThumb	ctermfg=fg	ctermbg=150	cterm=NONE
    hi TabLine	ctermfg=fg	ctermbg=250	cterm=NONE
    hi TabLineFill	ctermfg=fg	ctermbg=250	cterm=NONE
    hi TabLineSel	ctermfg=fg	ctermbg=NONE	cterm=NONE
    hi CursorColumn	ctermfg=NONE	ctermbg=216
    hi CursorLine	ctermfg=NONE	ctermbg=NONE	cterm=underline
    hi MatchParen	ctermfg=NONE	ctermbg=150
  endif

  hi TabLine		cterm=underline
  hi TabLineFill	cterm=underline
  hi CursorLine	cterm=underline

  " For reversed stuffs, clear the reversed prop and set the bold prop again
  hi IncSearch	cterm=bold
  hi StatusLine	cterm=bold
  hi StatusLineNC	cterm=bold
  hi VertSplit	cterm=bold
  hi Visual		cterm=bold

  hi NonText		cterm=bold
  hi Question		cterm=bold
  hi Title		cterm=bold
  hi DiffDelete	cterm=bold
  hi DiffText		cterm=bold
  hi Statement	cterm=bold
  hi Type		cterm=bold
  hi MoreMsg		cterm=bold
  hi ModeMsg		cterm=bold
  hi TabLineSel	cterm=bold

" Links:
"
" COLOR LINKS DEFINE START

hi link		String		Constant
" Character must be different from strings because in many languages
" (especially C, C++) a 'char' variable is scalar while 'string' is pointer,
" mistaken a 'char' for a 'string' will cause disaster!
hi link		Character	Number
hi link		SpecialChar	LineNr
hi link		Tag		Identifier
hi link		cCppOut		LineNr
hi link         ExtraWhitespace MatchParen

" COLOR LINKS DEFINE END

" vim:et:nosta:sw=2:ts=8:
" vim600:fdm=marker:fdl=1:
