let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if has('gui_running') && !exists('g:gui_loaded')
	set guifont=Consolas:h11:cANSI
	set lines=50 columns=200
else
    " Set the terminal default background and foreground colors, thereby
    " improving performance by not needing to set these colors on empty cells.
    hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
    let &t_ti = &t_ti . "\033]10;#e1e3e4\007\033]11;#2b2d3a\007"
    let &t_te = &t_te . "\033]110\007\033]111\007"
endif
let g:gui_loaded=1

" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
let &t_ut=''

"
" Plugins
"
call plug#begin('~/.vim/plugged')

" EasyMotion, quick movements around a file
Plug 'easymotion/vim-easymotion'
" Polyglot for language syntax highlighting
Plug 'sheerun/vim-polyglot'
" CoC
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Sonokai Colorscheme
Plug 'sainnhe/sonokai'
" Airline (bottom bar)
Plug 'vim-airline/vim-airline'
" Git Fugitive
Plug 'tpope/vim-fugitive'
" Git Gutter
Plug 'airblade/vim-gitgutter'
" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" fzf.vim
Plug 'junegunn/fzf.vim'
" typst support
Plug 'kaarmu/typst.vim'
" Github Copilot
Plug 'github/copilot.vim'

call plug#end()

"
" Colorschemes
"
set background=dark
if has('termguicolors')
	set termguicolors
endif
let g:sonokai_style='andromeda'
let g:sonokai_better_performance=1
colorscheme sonokai

"
" Misc
"
set nocompatible
set backspace=indent,eol,start
syntax on
filetype on
set number
set hlsearch
set encoding=utf-8
set nobackup
set nowritebackup

set updatetime=300
set signcolumn=yes

set noequalalways

"
" COC Bindings
"

" Use tab for trigger completion
inoremap <silent><expr> <Tab>
	\ coc#pum#visible() ? coc#pum#next(1) :
	\ CheckBackspace() ? "\<Tab>" :
	\ coc#refresh()
inoremap <expr><S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" <CR> accepts completed items
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
				\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Use <C-Space> to trigger completion
inoremap <silent><expr> <c-@> coc#refresh()

" COC Diagnostics
nmap <silent> <leader>cj <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>ck <Plug>(coc-diagnostic-next)
nmap <silent> <leader>cc :CocDiagnostics<CR>

" COC Documentation
nnoremap <silent> <leader>K :call ShowDocumentation()<CR>
function! ShowDocumentation()
	if CocAction('hasProvider', 'hover')
		call CocActionAsync('doHover')
	else
		call feedKeys('K', 'in')
	endif
endfunction

" COC Go To
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" Autohighlight on cursor hold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Scrolling in documentation/floating windows
if has('patch-8.2.0.0750')
	nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>" 
	inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>" 
endif

"
" Mappings
"
let mapleader=','
" Exit insert with jk
inoremap jk <Esc>
" Launch Explorer
map <Leader>E :Explore<CR>
" Show buffers and end with :b
nnoremap <Leader>l :ls<CR>:b<Space>
" Buffer Search
nnoremap <Leader>ll :Bs<Space>
" fzf git
nnoremap <Leader>sg :GFiles<CR>
" fzf files
nnoremap <Leader>sf :Files<CR>
" fzf ripgrep
nnoremap <Leader>sr :Rg<CR>
" fzf buffers
nnoremap <Leader>sb :Buffers<CR>

if has('nvim')
	tnoremap <C-w> <C-\><C-N>
	tnoremap <C-w>l <C-\><C-N><C-w>l
	tnoremap <C-w>k <C-\><C-N><C-w>k
	tnoremap <C-w>j <C-\><C-N><C-w>j
	tnoremap <C-w>h <C-\><C-N><C-w>h
endif

" Open a terminal across the bottom with a split vertical pane
if has('nvim')
	nmap <silent> <leader>ttn <C-w>n<C-w>v<C-w>j:term<CR>:res<Space>-30<CR><C-w>k
else
	nmap <silent> <leader>ttn :term<CR><C-w>R<C-w>:res<Space>-30<CR><C-w>k<C-w>v
endif

" Open a terminal on the right with an empty window on the left
if has('nvim')
	nmap <silent> <leader>tts <C-w>v<C-w>l:term<CR><C-w>h
else
	nmap <silent> <leader>tts :term<CR><C-w>H<C-w>R<C-w>h
endif

" Unbind useless S-k
map <S-k> <Nop>

" Black formatting
" Format the current buffer with Black
nnoremap <leader>bf :%!black -q -<CR>
com BlackFormat :%!black -q -

" Copilot
imap <silent><script><expr> <C-N> copilot#Accept("\<CR>")
imap <silent> <C-j> <Plug>(copilot-next)
imap <silent> <C-k> <Plug>(copilot-previous)
let g:copilot_no_tab_map = v:true
let g:copilot_workspace_folders = [getcwd()]
