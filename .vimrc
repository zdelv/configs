set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Vim-Fugitive
Plugin 'tpope/vim-fugitive'

" Color Schemes
Plugin 'flazz/vim-colorschemes'
Plugin 'drewtempelmeyer/palenight.vim'
Plugin 'morhetz/gruvbox'

" NERDTree
Plugin 'scrooloose/nerdtree'

" Vim GitGutter
Plugin 'airblade/vim-gitgutter'

" Vim Airline
"Plugin 'vim-airline/vim-airline'
"Plugin 'vim-airline/vim-airline-themes'

" quick-Scope
Plugin 'unblevable/quick-scope'

" C++ Highlighting
Plugin 'octol/vim-cpp-enhanced-highlight'

" Denite.vim
Plugin 'Shougo/denite.nvim'

" CtrlSpace
Plugin 'vim-ctrlspace/vim-ctrlspace'

" Commentary.vim
Plugin 'tpope/vim-commentary'

" ALE (Linting)
Plugin 'w0rp/ale'

" CtrlP
Plugin 'ctrlpvim/ctrlp.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on


"Non-Plugin Stuff 

" Background Color settings
syntax enable
set background=dark
colorscheme yosemite

" Make line numbers swap
" This makes Normal mode and Visual mode use hybrid but Insert use
" non-relative numbering.
:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END


" 4 Space indenting
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" " when indenting with '>', use 4 spaces width
set shiftwidth=4
" " On pressing tab, insert 4 spaces
set expandtab


" Shameles copy-paste from drumsetmonkey/.dotfiles
" Status
"---------------------------------
set laststatus=2
let g:currentmode={
    \ 'n'  : 'normal ',
    \ 'no' : 'n·operator pending ',
    \ 'v'  : 'visual ',
    \ 'V'  : 'v·line ',
    \ 'Vb' : 'v·block ',
    \ 's'  : 'select ',
    \ 'S'  : 's·line ',
    \ 'Sb' : 's·block ',
    \ 'i'  : 'insert ',
    \ 'R'  : 'replace ',
    \ 'Rv' : 'v·replace ',
    \ 'c'  : 'command ',
    \ 'cv' : 'vim ex ',
    \ 'ce' : 'ex ',
    \ 'r'  : 'prompt ',
    \ 'rm' : 'more ',
    \ 'r?' : 'confirm ',
    \ '!'  : 'shell ',
    \ 't'  : 'terminal '}

highlight PrimaryBlock ctermfg=007 guibg=#384779 guifg=fgcolor
highlight SecondaryBlock ctermfg=008 guibg=#222B4A guifg=bgcolor
highlight TeritaryBlock ctermfg=008 guibg=#13192D guifg=bgcolor

" TODO Add new things for auto switching color on mode swap

set statusline=
set statusline+=%#PrimaryBlock#
set statusline+=\ %{g:currentmode[mode()]}
set statusline+=%#SecondaryBlock#
set statusline+=%{StatuslineGit()}
set statusline+=%#TeritaryBlock#
set statusline+=\ %f\ 
set statusline+=%M\ 
set statusline+=%#TeritaryBlock#
set statusline+=%=
set statusline+=%#SecondaryBlock#
set statusline+=\ %Y\ 
set statusline+=%#PrimaryBlock#
set statusline+=\ %P\ 

function! GitBranch()
	return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
	let l:branchname = GitBranch()
	return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction<Paste>



map <Up> <Nop>
map <Down> <Nop>
map <Left> <Nop>
map <Right> <Nop>
map <PageUp> <Nop>
map <PageDown> <Nop>

imap <Up> <Nop>
imap <Down> <Nop>
imap <Left> <Nop>
imap <Right> <Nop>
imap <PageUp> <Nop>
imap <PageDown> <Nop>
imap jk <Esc>



" Some of this stuff isn't needed

if (has("nvim"))
	"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
 let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
	set termguicolors
endif

" CtrlSpace settings
"set nocompatible
"set hidden

" ALE Settings
" CPP and SH
let g:ale_fixers = {
\   'cpp' : ['remove_trailing_lines','trim_whitespace','clang-format'],
\   'sh'  : ['remove_trailing_lines','trim_whitespace','shfmt'],
\}
