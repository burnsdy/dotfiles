" GENERAL CONFIG
" Best practice to set nocompatible (use Vim instead of vi) explictly at the top of .vimrc
set nocompatible									" Switches from default vi-compatibility mode and enables Vim functionality
set exrc											" Sources a local vimrc if one is available
set shortmess+=I									" Disable Vim startup message
set hidden											" Allow hidden buffers
set visualbell										" Set visual bell instead of audible bell
set t_vb=	
if has('mouse')										" Enable mouse support for all modes
  set mouse=a
endif									
set encoding=utf-8									" Set encoding to UTF-8


" SAVING
set confirm											" Ask to save changed files
set nobackup										" Don't save backup files
set nowritebackup
set noswapfile										" Gets rid of temporary swapfiles
set autoread										" Automatically read file into buffer if it has been changed outside Vim
au FocusLost,WinLeave * :silent! wa					" Save whenever switching windows or leaving vim
au FocusGained,BufEnter * :silent! !				" Trigger autoread when changing buffers or coming back to vim.
set updatetime=300


" DISPLAY
set laststatus=2									" Always show status line at the bottom
set cmdheight=2
if !&scrolloff
  set scrolloff=12
endif
if !&sidescrolloff
  set sidescrolloff=20
endif
set display+=lastline
if has('syntax') && !exists('g:syntax_on')			" Enable syntax highlighting
  syntax enable
endif
if &t_Co == 8 && $TERM !~# '^Eterm'					" Allow color schemes to do bright colors without forcing bold
  set t_Co=16
endif
set showmode										" Show mode on the last line
set number											" Line numbers
set ruler
set signcolumn=yes									" Adds sign column to the left of line numbers
if &listchars ==# 'eol:$'							" Setting basic listchars
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif


" COMMANDS
set wildmenu										" Better command-line completion
set showcmd											" Show partial commands in last line of screen
set complete-=i
set nostartofline									" Stop certain movements from going to the first character of a line
set nrformats-=octal
if !has('nvim') && &ttimeoutlen == -1				" Never time out on mappings, quickly time out on keycodes
  set ttimeout
  set ttimeoutlen=50
endif
if v:version > 703 || v:version == 703 && has("patch541")	
  set formatoptions+=j 								" Delete comment character when joining commented lines
endif


" INDENTING
if has('autocmd')									" Enable intelligent auto-indenting based on file type
  filetype indent plugin on
endif
set autoindent										" Keep same indent as previous line when opening new line
set smartindent
set smarttab
set shiftwidth=4									" Set indentation width for tabs
set tabstop=4
set softtabstop=4
set expandtab
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab


" SEARCHING
set ignorecase										" Case-insensitive searching
set smartcase										" Case-sensitive searching if search contains any capital letters
set incsearch										" Allow searching as you type
set hlsearch										" Highlight searches


" PLUGINS
call plug#begin('~/.vim/plugged')
" Vim Plugins
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'godlygeek/tabular'
Plug 'markonm/traces.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
Plug 'plasticboy/vim-markdown'
"Plug 'dkarter/bullets.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'tpope/vim-repeat'
Plug 'kshenoy/vim-signature'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
" NeoVim Plugins
if has('nvim')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
" Themes
Plug 'morhetz/gruvbox'
Plug 'lifepillar/vim-gruvbox8'
Plug 'dracula/vim',{'as':'dracula'}
Plug 'sonph/onehalf',{'rtp':'vim/'}
Plug 'arcticicestudio/nord-vim'
Plug 'sainnhe/sonokai'
call plug#end()


" PLUGIN SETTINGS
" Conquer of Completion
if has('nvim')
	let g:coc_global_extensions = ['coc-highlight', 'coc-prettier', 'coc-eslint', 'coc-word', 'coc-json', 'coc-tsserver', 'coc-styled-components']
	autocmd VimEnter *.md call CocActionAsync('deactivateExtension', 'coc-highlight')
	autocmd BufNew,BufEnter *.md call CocActionAsync('deactivateExtension', 'coc-highlight')
	autocmd BufLeave *.md call CocActionAsync('activeExtension', 'coc-highlight')
	source ~/.nvim/cocconf.vim
endif
" NERDCommenter
let g:NERDSpaceDelims = 1									" Add spaces after comment delimiters by default
let g:NERDCommentEmptyLines = 1								" Allow commenting and inverting empty lines
" NERDTree
let NERDTreeShowHidden = 1									" Show hidden files by default
let NERDTreeMinimalUI = 1									" Remove 'Press ? for help'
let NERDTreeDirArrows = 1									" Improve NERDTree UI
let NERDTreeQuitOnOpen = 1									" Close NERDTree when a file is opened
															" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
															" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
" Airline
let g:airline#extensions#tabline#enabled = 1				" Enable buffer display as tabs extension
let g:airline#extensions#tabline#formatter = 'unique_tail'	" Theme for buffer extension
let g:airline_powerline_fonts = 1							" Configure airline to use the powerline font
" Vim Surround
let g:surround_{char2nr('b')} = "**\r**"
let g:surround_{char2nr('c')} = "```\n\r\n```"
" Vim Markdown
let g:markdown_fenced_languages = ['c', 'cpp', 'css', 'go', 'html', 'java', 'javascript', 'js=javascript', 'json=javascript', 'python', 'vim']
let g:vim_markdown_strikethrough = 1						" Allow strikethrough formatting in Markdown
let g:vim_markdown_new_list_item_indent = 0					" Keep same indent level when adding new list items
let g:vim_markdown_autowrite = 1							" Automatically save in the current document when following a link
let g:vim_markdown_edit_url_in = 'tab'						" Open links in a new tab and not the current buffer
let g:vim_markdown_follow_anchor = 1						" Allows ge command to follow named anchors in links in the form of file#anchor
let g:markdown_minlines = 300
" Bullets.vim
"let g:bullets_enabled_file_types = ['markdown', 'text', 'gitcommit', 'scratch']
"let g:bullets_outline_levels = ['ROM', 'ABC', 'num', 'abc', 'rom', 'std-']


" THEME SETTINGS
let g:gruvbox_italics = 1
let g:gruvbox_underline = 1
let g:gruvbox_undercurl = 1
let g:gruvbox_number_column = 'bg0'
let g:gruvbox_sign_column = 'bg0'
let g:gruvbox_color_column = 'bg0'
let g:gruvbox_invert_selection = 0
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_contrast_light = 'medium'
autocmd FileType markdown setlocal background=light
colorscheme gruvbox
let g:airline_theme = 'gruvbox'


" KEY BINDINGS
" General
" Make backspace behave more intuitively
set backspace=indent,eol,start
nnoremap <space> <Nop>
let mapleader=" "
nmap Q <Nop>
nnoremap J 10j
nnoremap K 10k
vnoremap J 10j
vnoremap K 10k
nnoremap <C-D> 20j
nnoremap <C-U> 20k
nnoremap Y y$
nnoremap X cl
" Map gI to Vim gi because mapping is overridden by coc.nvim
nnoremap gI gi
nnoremap gw ^
vnoremap gw ^
nnoremap gW $
vnoremap gW $
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>p "0p<CR>
nnoremap <leader>P "0P<CR>
nnoremap <leader>y "*y<CR>
nnoremap <leader>Y "*Y<CR>
nnoremap <leader>yy "*yy<CR>
vnoremap <leader>y "*y<CR>
nnoremap <leader>n :nohl<CR>
nnoremap <silent> <C-L> :nohl<CR><C-L>
nnoremap <leader>j J

" Tab/Buffer Navigation
nnoremap <silent> gt :tabnext<CR>
nnoremap <silent> gT :tabprevious<CR>
nnoremap <leader>b :buffers<CR>:buffer<space>
nnoremap <silent> <leader>d :bdelete<CR>
nnoremap <silent> L :bnext<CR>
nnoremap <silent> H :bprevious<CR>
vnoremap <silent> L :bnext<CR>
vnoremap <silent> H :bprevious<CR>
nnoremap <silent> <leader>l <C-W>l
nnoremap <silent> <leader>h <C-W>h
vnoremap <silent> <leader>l <C-W>l
vnoremap <silent> <leader>h <C-W>h

" Plugins
nnoremap <leader>t :NERDTreeMirror<CR>:NERDTreeToggle<CR>
" Reveal current file in NERDTree
nnoremap <leader>v :NERDTreeFind<CR>:NERDTreeMirror<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>r :Rg<CR>
cnoreabbrev pi PlugInstall
cnoreabbrev pc PlugClean
cnoreabbrev pu PlugUpdate
cnoreabbrev pr Prettier
