set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
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
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" quick-Scope
Plugin 'unblevable/quick-scope'

" C++ Highlighting
Plugin 'octol/vim-cpp-enhanced-highlight'

" Denite.vim
Plugin 'Shougo/denite.nvim'

" " fzf
" set rtp+=/usr/local/opt/fzf
" Plugin 'junegunn/fzf.vim'

" CtrlSpace
" Plugin 'vim-ctrlspace/vim-ctrlspace'

" Commentary.vim
Plugin 'tpope/vim-commentary'

" ALE (Linting)
Plugin 'w0rp/ale'


" plugin from http://vim-scripts.org/vim/scripts.html

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Background Color settings
syntax enable
set background=dark
colorscheme gruvbox

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


if (has("nvim"))
	"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
 let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
	set termguicolors
endif

" function! s:fzf_statusline()
"   " Override statusline as you like
"   highlight fzf1 ctermfg=161 ctermbg=251
"   highlight fzf2 ctermfg=23 ctermbg=251
"   highlight fzf3 ctermfg=237 ctermbg=251
"   setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
" endfunction

" autocmd! User FzfStatusLine call <SID>fzf_statusline()

" CtrlSpace settings
set nocompatible
set hidden

" ALE Settings
let g:ale_fixers = {
\   'cpp' : ['remove_trailing_lines','trim_whitespace','clang-format'],
\   'sh'  : ['remove_trailing_lines','trim_whitespace','shfmt'],
\}
let g:airline#extensions#ale#enabled = 1

noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>

"imap <C-m> <C-n><C-p>
