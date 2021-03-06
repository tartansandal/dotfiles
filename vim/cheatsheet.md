# Vim Cheetsheet

## Personal Shortcuts

  \<space> - one window
  Ctrl-L  - clear search highlighting

  \a - autoformat   [may not need this anymore use \rf instead]

  \g - open Fugitive Status
  \\G - open file in github

  \u - toggle undo tree
  \n - find current file in NERDTree

  \? - goto this cheatsheet
  \N - goto Notes directory

  Ctrl-Tab  Swicther
  Ctrl-\    Switcher


## ALE

  [g  - goto prev diagnostic
  ]g  - goto next diagnostic

  \f  - fix (reformat) selection or buffer

## CoC

  gd  - goto definition
  gr  - goto references

  gy  - goto type-definition
  gi  - goto implementation

  K   - to show documentation in preview window

  \rn - rename symbol
  \a  - codeaction on selection/object/motion
  \ac - codeaction on whole buffer

  SPACE a - Show all diagnostics
  SPACE e - Manage extensions
  SPACE c - Show commands
  SPACE o - Find symbol in current document
  SPACE s - Search workspace symbols
  SPACE j - Do default action for next item.
  SPACE k - Do default action for previous item.
  SPACE p - Resume latest coc list

  :Fold   - fold current buffer
  :OR     - organize import of current buffer

## TextObjects

  Two caracter sequences: <prefix><suffix>

  The prefix "a" selects "around" an object, *including* its delimiters
  The prefix "i" selects "inside" object, *excluding* its delimiters

  There are various suffixes:

    suffix     | matches
    --------------------------------------------------------------------
    w, W, s, p | word, Word, sentence, paragraph delimited by whitespace
    ", ', `    | string delimited by matching marks
    [, {, (, > | block delimited by matching pairs
    t          | XML tag block delimited by tag
    f, c       | function, class object delimited by programming stucture
    i          | indentation level, delimited by line above
    u          | url delimited by whitespace

## Completion

  i_TAB - trigger completion
          repeat for next selection
          S-TAB for previous selection
          CR to configure completion

  n_TAB - select selections ranges ???

  Ctrl-SPACE - trigger completion without adding characters?

## Globals

  g~{Motion} or {Visual}~  - togglecase
  gU{Motion} or {Visual}U  - uppercase
  gu{Motion} or {Visual}u  - lowercase

  gc{Motion} or {Visual}gc - toggle comment

  gf open file under cursor
  gx open path under cursor externally

## Window Scrolling

  Ctrl-e   Ctrl-y   scroll down/up by lines
  Ctrl-d   Ctrl-u   scroll down/up by half-pages
  Ctrl-f   Ctrl-b   scroll forward/back> by full pages
  S-Up S-Down       scroll forward/back> by full pages

## Grep

  :gr[ep] args

  \vv     - grep for word under cursor
  \vV     - grep for WORD under cursor
  \cf     - grep for file under cursor

  :cw     - show quickfix window

## Motion

  Shift-Down   - to window down
  Shift-Up     - to window up
  Shift-Right  - to window right
  Shift-Left   - to window left

  Ctrl-Right  - to next tab
  Ctrl-Left   - to prev tab

  (could we integrate these with unimpaired?)
  maybe [w cycle forwar ]w cycle back

  Or maybe Shift-Tab to cycle windows

## Fugitive

  :Gw[rite]
  :Gr[ead]
  :Gdiff [revision]
  :Gedit [revision]
  :Gvsplit [revision]

  :Gco[mmit]
  :Gst[atus]

  :GMove {destination}
  :GRename {destination}
  :GDelete
  :GRemove
  :GBrowse

  :G pull
  :G push
  :G fetch
  :G merge
  :G blame
  :G difftool
  :G mergetool

  :Glog
  :Gblame

  \g - open fugitive status

  Inside status do `g?` to show help

## Folding

  za - fold toggle
  zM - fold all
  zm - fold more
  zr - fold reduce
  zR - fold none

## Spelling

  [os	  ]os   =os   on/off/toggle spelling

  [s - prev mistake
  ]s - next mistake

  zg - mark word as good
  zw - mark word as wrong
  z= - spell suggestions

## Unimpaired

  | prev  | next | first | last | operates on
  | ----- | ---- | ----- | ---- | -------------
  | [a    | ]a   | [A    | ]A   | argument list
  | [b    | ]b   | [B    | ]B   | buffer list
  | [l    | ]l   | [L    | ]L   | location list
  | [q    | ]q   | [Q    | ]Q   | quickfix list
  | [t    | ]t   | [T    | ]T   | tag list

-- location list
[<C-L> - next marker in next file
]<C-L> - prev marker in prev file

-- quickfix list
[<C-Q> - prev marker in next file
]<C-Q> - next marker in next file

-- files in the current files directory
[f - prev alphabetically
]f - next alphabetically

-- SCM markers
[n - prev
]n - next

-- add space
[<space> - above
]<space> - below

-- exchange line with
[e - line above
]e - line below

  | On   | Off  | Toggle | Option
  |------|------|--------|----------
  | [oh	 | ]oh  | =oh    | hlsearch
  | [oi	 | ]oi  | =oi    | ignorecase
  | [ol	 | ]ol  | =ol    | list
  | [on	 | ]on  | =on    | number
  | [or	 | ]or  | =or    | relativenumber
  | [os	 | ]os  | =os    | spell
  | [ov	 | ]ov  | =ov    | virtualedit
  | [ow	 | ]ow  | =ow    | wrap
  | [oc	 | ]oc  | =oc    | cursorline
  | [ou	 | ]ou  | =ou    | cursorcolumn
  | [ox	 | ]ox  | =ox    | cursorline cursorcolumn (x as in crosshairs)
  | [od	 | ]od  | =od    | diff (actually |:diffthis| / |:diffoff|)

  | Encode | Decode |  target
  | -------|--------|--------
  | [x     | ]x     |  XML
  | [u     | ]u     |  URL
  | [y     | ]y     |  C String (backslash special chars)
  (these accept motion and visual args)

## Suround

X or Y are one of the chars (prefer closing) in the following pairs:

```
'' "" `` [] {} () <>
```

dsX  - delete surrounding X
csXY - change surrounding X to Y

ys{motion}X - you surround {motion} with X
yS{motion}X - you surround {motion} with X indented on its own line

SX - surround visual selction with X


<!-- ## FZF -->

<!-- All have \f prefix -->

<!--   \fb :Buffers -->
<!--   \ff :GFiles -->
<!--   \fF :Files -->

<!--   \fh :History -->
<!--   \f: :History: -->
<!--   \f/ :History/ -->

<!--   \ft :BTags -->
<!--   \fT :Tags -->

<!--   \fl :BLines -->
<!--   \fL :Lines -->

<!--   \fm :Methods -->
<!--   \fh :History -->
<!--   \fH :Helptags! -->
<!--   \fM :Maps -->
<!--   \fC :Commands -->
<!--   \f' :Marks -->
<!--   \fs :Filetypes -->
<!--   \fS :Snippets -->

