" vim600: set foldmethod=marker:
"
" Version:      1.4
" Description:  Per buffer, togglable syntax highlighting of tabs and trailing
"               spaces.
" Author:       Adam Lazur <adam@lazur.org>, extended by Jonathan Palardy
" URL:          https://github.com/jpalardy/spacehi.vim
" License:      Redistribution and use of this file, with or without
"               modification, are permitted without restriction.
"
" Section: Documentation {{{1
"
" This plugin will highlight tabs, nbsps and trailing spaces on a line, with the
" ability to toggle the highlighting on and off. Using highlighting to
" illuminate these characters is preferrable to using listchars and set list
" because it allows you to copy from the vim window without getting shrapnel
" in your buffer.
"
" NOTE: "set list" will override SpaceHi's highlighting.
"
" Highlighting can be turned on and off with the functions SpaceHi() and
" NoSpaceHi() respectively. You can also toggle the highlighting state by
" using ToggleSpaceHi(). By default, ToggleSpaceHi is bound to the key F3.
"
" You can customize the colors by setting the following variables to a string
" of key=val that would normally follow "highlight group" command:
"
"       g:spacehi_spacecolor
"       g:spacehi_tabcolor
"       g:spacehi_nbspcolor
"
" The defaults can be found in the "Default Global Vars" section below.
"
" You can give a list of filetypes to exclude
"
" If you want to highlight tabs and trailing spaces by default for every file
" that is syntax highlighted, you can add the following to your vimrc:
"
"       autocmd syntax * SpaceHi
"
" The author currently uses the following (a little overboard) in his vimrc:
"
"   autocmd BufNewFile,BufReadPost,FilterReadPost,FileReadPost,Syntax * SpaceHi
"   au FileType help NoSpaceHi

" Section: Plugin header {{{1
" If we have already loaded this file, don't load it again.
if exists("loaded_spacehi")
    finish
endif
let loaded_spacehi=1

" Section: Default Global Vars {{{1
if !exists("g:spacehi_color")
    " highlight unwanted whitespace with red background
    let g:spacehi_color="ctermfg=White ctermbg=Red guifg=White guibg=Red"
endif
if !exists("g:spacehi_tabcolor")
    let g:spacehi_tabcolor=g:spacehi_color
endif
if !exists("g:spacehi_spacecolor")
    let g:spacehi_spacecolor=g:spacehi_color
endif
if exists("g:spacehi_nbspcolor") && !exists("g:spacehi_unicodecolor")
    " backwards compatibility with deprecated variable
    let g:spacehi_unicodecolor=g:spacehi_nbspcolor
endif
if !exists("g:spacehi_unicodecolor")
    let g:spacehi_unicodecolor=g:spacehi_color
endif

" Section: Unicode whitespace pattern {{{1
let s:unicode_pattern='['
let s:unicode_pattern.='\u00A0' " NO-BREAK SPACE
let s:unicode_pattern.='\u1680' " OGHAM SPACE MARK
let s:unicode_pattern.='\u180E' " MONGOLIAN VOWEL SEPARATOR
let s:unicode_pattern.='\u2000' " EN QUAD
let s:unicode_pattern.='\u2001' " EM QUAD
let s:unicode_pattern.='\u2002' " EN SPACE
let s:unicode_pattern.='\u2003' " EM SPACE
let s:unicode_pattern.='\u2004' " THREE-PER-EM SPACE
let s:unicode_pattern.='\u2005' " FOUR-PER-EM SPACE
let s:unicode_pattern.='\u2006' " SIX-PER-EM SPACE
let s:unicode_pattern.='\u2007' " FIGURE SPACE
let s:unicode_pattern.='\u2008' " PUNCTUATION SPACE
let s:unicode_pattern.='\u2009' " THIN SPACE
let s:unicode_pattern.='\u200A' " HAIR SPACE
let s:unicode_pattern.='\u200B' " ZERO WIDTH SPACE
let s:unicode_pattern.='\u202F' " NARROW NO-BREAK SPACE
let s:unicode_pattern.='\u205F' " MEDIUM MATHEMATICAL SPACE
let s:unicode_pattern.='\u3000' " IDEOGRAPHIC SPACE
let s:unicode_pattern.='\uFEFF' " ZERO WIDTH NO-BREAK SPACE
let s:unicode_pattern.=']'

" Section: Functions {{{1
" Function: s:SpaceHi() {{{2
" Turn on highlighting of spaces and tabs
function! s:SpaceHi()
    " highlight tabs
    syntax match spacehiTab /\t/ containedin=ALL
    execute("highlight spacehiTab " . g:spacehi_tabcolor)

    " highlight trailing spaces
    syntax match spacehiTrailingSpace /\s\+$/ containedin=ALL
    execute("highlight spacehiTrailingSpace " . g:spacehi_spacecolor)

    " highlight unicode whitespace
    execute('syntax match spacehiUnicode /'. s:unicode_pattern .'/ containedin=ALL')
    execute("highlight spacehiUnicode " . g:spacehi_unicodecolor)

    let b:spacehi = 1
endfunction

" Function: s:NoSpaceHi() {{{2
" Turn off highlighting of spaces and tabs
function! s:NoSpaceHi()
    syntax clear spacehiTab
    syntax clear spacehiTrailingSpace
    syntax clear spacehiUnicode
    let b:spacehi = 0
endfunction

" Function: s:ToggleSpaceHi() {{{2
" Toggle highlighting of spaces and tabs
function! s:ToggleSpaceHi()
    if exists("b:spacehi") && b:spacehi
        call s:NoSpaceHi()
        echo "spacehi off"
    else
        call s:SpaceHi()
        echo "spacehi on"
    endif
endfunction

" Section: Commands {{{1
com! SpaceHi call s:SpaceHi()
com! NoSpaceHi call s:NoSpaceHi()
com! ToggleSpaceHi call s:ToggleSpaceHi()

" Section: Default mappings {{{1
" Only insert a map to ToggleSpaceHi if they don't already have a map to
" the function and don't have something bound to F3
if !hasmapto('ToggleSpaceHi') && maparg("<F3>") == ""
  map <silent> <unique> <F3> :ToggleSpaceHi<CR>
endif
