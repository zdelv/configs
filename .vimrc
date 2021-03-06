set nocompatible              " be iMproved, required
filetype off                  " required

let mapleader = ","

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
Plugin 'guns/xterm-color-table.vim'
Plugin 'dylanaraps/wal.vim'
Plugin 'chrisbra/Colorizer'

" NERDTree
Plugin 'scrooloose/nerdtree'

" Vim GitGutter
Plugin 'airblade/vim-gitgutter'

" Vim Airline
"Plugin 'vim-airline/vim-airline'
"Plugin 'vim-airline/vim-airline-themes'

" Delimitmate
Plugin 'raimondi/delimitmate'

" quick-Scope
Plugin 'unblevable/quick-scope'

" C++ Highlighting
Plugin 'octol/vim-cpp-enhanced-highlight'

" Denite.vim
Plugin 'Shougo/denite.nvim'

" Commentary.vim
Plugin 'tpope/vim-commentary'

" ALE (Linting)
Plugin 'w0rp/ale'

" Gutentags
Plugin 'ludovicchabant/vim-gutentags'

" Goyo
Plugin 'junegunn/goyo.vim'

" vim-workspace
Plugin 'thaerkh/vim-workspace'

" NCM
Plugin 'roxma/nvim-completion-manager'

" vimtex
Plugin 'lervag/vimtex'

" CSV
Plugin 'chrisbra/csv.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on


"Non-Plugin Stuff 
"or Plugin settings


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
" show existing tab with 4 spaces width set tabstop=4 " when indenting with '>', use 4 spaces width
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
    \ '' : 'v·block ',
    \ 's'  : 'select ',
    \ 'S'  : 's·line ',
    \ '' : 's·block ',
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

" Remove --Insert-- and other mode signifiers
set noshowmode

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

" Map J and K to move by display lines
map j gj
map k gk

" Escape and One-shot
imap jl <C-o>
imap jk <Esc>

" Tab settings
nnoremap <C-y> gt
nnoremap <C-t> gT

" Background Color settings
syntax enable
set background=dark
colorscheme yosemite
set t_Co=256

" denite

if has('nvim')
  " reset 50% winheight on window resize
  augroup deniteresize
    autocmd!
    autocmd VimResized,VimEnter * call denite#custom#option('default',
          \'winheight', winheight(0) / 2)
  augroup end

  call denite#custom#option('default', {
        \ 'prompt': '❯'
        \ })

  call denite#custom#var('file_rec', 'command',
        \ ['rg', '--files', '--glob', '!.git', ''])
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--hidden', '--vimgrep', '--no-heading', '-S'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#map('insert', '<Esc>', '<denite:enter_mode:normal>',
        \'noremap')
  call denite#custom#map('insert', 'jk', '<denite:enter_mode:normal>',
        \'noremap')
  call denite#custom#map('normal', '<Esc>', '<NOP>',
        \'noremap')
  call denite#custom#map('insert', '<C-v>', '<denite:do_action:vsplit>',
        \'noremap')
  call denite#custom#map('normal', '<C-v>', '<denite:do_action:vsplit>',
        \'noremap')
  call denite#custom#map('normal', 'dw', '<denite:delete_word_after_caret>',
        \'noremap')
endif

nnoremap <C-p> :<C-u>Denite file_rec<CR>
nnoremap <leader>s :<C-u>Denite buffer<CR>
nnoremap <leader><Space>s :<C-u>DeniteBufferDir buffer<CR>
nnoremap <leader>8 :<C-u>DeniteCursorWord grep:. -mode=normal<CR>
nnoremap <leader>/ :<C-u>Denite grep:. -mode=normal<CR>
nnoremap <leader><Space>/ :<C-u>DeniteBufferDir grep:. -mode=normal<CR>
nnoremap <leader>d :<C-u>DeniteBufferDir file_rec<CR>

hi link deniteMatchedChar Special
hi WildMenu guifg=white guibg=NONE gui=bold


" Some of this stuff isn't needed

if (has("nvim"))
	"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
 let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" if (has("termguicolors"))
" 	set termguicolors
" endif

" This makes substitute replace while typing
set inccommand=nosplit

" ALE Settings
" CPP and SH
let g:ale_fixers = {
\   'cpp' : ['remove_trailing_lines','trim_whitespace'],
\   'sh'  : ['remove_trailing_lines','trim_whitespace','shfmt'],
\}
