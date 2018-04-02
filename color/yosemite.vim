" Vim color file
" yosemite
" Created by  with ThemeCreator (https://github.com/mswift42/themecreator)
" Edited by zdelv

hi clear

if exists("syntax on")
syntax reset
endif

set t_Co=256
let g:colors_name = "yosemite"


" Define reusable colorvariables.
let s:bg="#13192D"
let s:fg="#F4D6F6"
let s:fg2="#e8e8e8"
let s:fg3="#d4d4d4"
let s:fg4="#c0c0c0"
let s:bg2="#3b3b3b"
let s:bg3="#4c4c4c"
let s:bg4="#5d5d5d"
let s:keyword="#90D4EE"
let s:builtin="#8d99d6"
let s:const="#5457ec"
let s:comment="#7A7795"
let s:func="#6086cd"
let s:str="#ea78c8"
let s:type="#be6bd3"
let s:var="#e5a6e1"
let s:warning="#211fe5"
let s:warning2="#ca15e9"

exe 'hi Normal guifg='s:fg' guibg='s:bg 
exe 'hi Cursor guifg='s:bg' guibg='s:fg 
exe 'hi Cursorline  guibg='s:bg2 
exe 'hi CursorLineNr guifg='s:type
exe 'hi CursorColumn  guibg='s:bg2 
exe 'hi ColorColumn  guibg='s:bg2 
exe 'hi LineNr guifg='s:fg2' guibg='s:bg 
exe 'hi VertSplit guifg='s:fg3' guibg='s:bg3 
exe 'hi MatchParen guifg='s:warning2'  gui=underline'
exe 'hi StatusLine guifg='s:fg2' guibg='s:bg3' gui=bold'
exe 'hi Pmenu guifg='s:fg' guibg='s:bg2
exe 'hi PmenuSel  guibg='s:bg3 
exe 'hi IncSearch guifg='s:bg' guibg='s:keyword 
exe 'hi Search   gui=underline guibg='s:var
exe 'hi Directory guifg='s:const  
exe 'hi Folded guifg='s:fg4' guibg='s:bg 
exe 'hi SignColumn guibg=NONE'
exe 'hi Todo gui=bold guibg=NONE guifg='s:keyword

exe 'hi Boolean guifg='s:const  
exe 'hi Character guifg='s:const  
exe 'hi Comment guifg='s:comment  
exe 'hi Conditional guifg='s:keyword  
exe 'hi Constant guifg='s:const  
exe 'hi Define guifg='s:keyword  
exe 'hi DiffAdd guifg=#f8f8f8 guibg=#46830c gui=bold'
exe 'hi DiffDelete guifg=#ff0000'  
exe 'hi DiffChange guifg='s:fg' guibg='s:var 
exe 'hi DiffText guifg='s:fg' guibg='s:builtin' gui=bold'
exe 'hi ErrorMsg guifg='s:warning2' guibg=NONE gui=bold'
exe 'hi WarningMsg guifg='s:fg' guibg='s:warning2 
exe 'hi Float guifg='s:const  
exe 'hi Function guifg='s:func  
exe 'hi Identifier guifg='s:type'  gui=italic'
exe 'hi Keyword guifg='s:keyword'  gui=bold'
exe 'hi Label guifg='s:var
exe 'hi NonText guifg='s:bg4' guibg='s:bg2 
exe 'hi Number guifg='s:const  
exe 'hi Operater guifg='s:keyword  
exe 'hi PreProc guifg='s:keyword  
exe 'hi Special guifg='s:fg  
exe 'hi SpecialKey guifg='s:fg2' guibg='s:bg2 
exe 'hi Statement guifg='s:keyword  
exe 'hi StorageClass guifg='s:type'  gui=italic'
exe 'hi String guifg='s:str  
exe 'hi Tag guifg='s:keyword  
exe 'hi Title guifg='s:fg'  gui=bold'
exe 'hi Type guifg='s:type 
exe 'hi Underlined   gui=underline'
exe 'hi EndOfBuffer guibg=NONE'
exe 'hi Error guibg='s:warning2

" Ruby Highlighting
exe 'hi rubyAttribute guifg='s:builtin
exe 'hi rubyLocalVariableOrMethod guifg='s:var
exe 'hi rubyGlobalVariable guifg='s:var' gui=italic'
exe 'hi rubyInstanceVariable guifg='s:var
exe 'hi rubyKeyword guifg='s:keyword
exe 'hi rubyKeywordAsMethod guifg='s:keyword' gui=bold'
exe 'hi rubyClassDeclaration guifg='s:keyword' gui=bold'
exe 'hi rubyClass guifg='s:keyword' gui=bold'
exe 'hi rubyNumber guifg='s:const

" Python Highlighting
exe 'hi pythonBuiltinFunc guifg='s:builtin

" Go Highlighting
exe 'hi goBuiltins guifg='s:builtin

" Javascript Highlighting
exe 'hi jsBuiltins guifg='s:builtin
exe 'hi jsFunction guifg='s:keyword' gui=bold'
exe 'hi jsGlobalObjects guifg='s:type
exe 'hi jsAssignmentExps guifg='s:var

" Html Highlighting
exe 'hi htmlLink guifg='s:var' gui=underline'
exe 'hi htmlStatement guifg='s:keyword
exe 'hi htmlSpecialTagName guifg='s:keyword

" Markdown Highlighting
exe 'hi mkdCode guifg='s:builtin

" StatusBar coloring
exe 'hi PrimaryBlock guibg=#384779 guifg='s:fg
" hi PrimaryBlock ctermfg=007 guibg=#384779 guifg=fgcolor
hi SecondaryBlock ctermfg=008 guibg=#222B4A guifg=bgcolor
hi TeritaryBlock ctermfg=008 guibg=#13192D guifg=bgcolor

" Plugin Stuff Below

" GitGutter
hi! link GitGutterAdd CursorLineNr
hi! link GitGutterDelete Statement
exe 'hi GitGutterChange guifg='s:fg

" CtrlSpace Coloring
hi CtrlSpaceNormal guibg=NONE
hi CtrlSpaceSelected guibg=NONE gui=bold
hi! link CtrlSpaceStatus SecondaryBlock
