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
set noswapfile										" Gets rid of temporary swapfiles
set autoread										" Automatically read file into buffer if it has been changed outside Vim
au FocusLost,WinLeave * :silent! wa					" Save whenever switching windows or leaving vim
au FocusGained,BufEnter * :silent! !				" Trigger autoread when changing buffers or coming back to vim.
set updatetime=1000


" FORMATTING 
set laststatus=2									" Always show status line at the bottom
if !&scrolloff
  set scrolloff=10
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline
if has('syntax') && !exists('g:syntax_on')			" Enable syntax highlighting
  syntax enable
endif
if &t_Co == 8 && $TERM !~# '^Eterm'					" Allow color schemes to do bright colors without forcing bold
  set t_Co=16
endif
set conceallevel=2									" Use Vim's standard syntax concealing
set showmode										" Show mode on the last line
set cursorline										" Highlight line under cursor horizontally
set number											" Line numbers
set relativenumber
set ruler
set signcolumn=yes									" Adds sign column to the left of line numbers
													" Change line number and gutter color
"highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
if &listchars ==# 'eol:$'							" Setting basic listchars
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
if v:version > 703 || v:version == 703 && has("patch541")	
  set formatoptions+=j 								" Delete comment character when joining commented lines
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
Plug 'Yggdroot/indentLine'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'godlygreek/tabular'
Plug 'markonm/traces.vim'
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-repeat'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
" NeoVim Plugins
if has('nvim')
endif
" Themes
Plug 'dracula/vim',{'as':'dracula'}
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'sainnhe/sonokai'
call plug#end()


" PLUGIN SETTINGS
" NERDCommenter
let g:NERDSpaceDelims = 1									" Add spaces after comment delimiters by default
let g:NERDCommentEmptyLines = 1								" Allow commenting and inverting empty lines
" NERDTree
let NERDTreeShowHidden=1									" Show hidden files by default
autocmd StdinReadPre * let s:std_in=1						" Start NERDTree when Vim starts with a directory argument.
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
															" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
															" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
" Airline
let g:airline#extensions#tabline#enabled = 1				" Enable buffer display as tabs extension
let g:airline#extensions#tabline#left_sep = ' '				" Define separators for buffer extension to display as 'straight' tabs
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'	" Theme for buffer extension
" Vim Markdown
let g:markdown_fenced_languages = ['c', 'cpp', 'css', 'go', 'html', 'java', 'javascript', 'js=javascript', 'json=javascript', 'python', 'ruby', 'rust', 'sass', 'vim', 'xml']
let g:vim_markdown_strikethrough = 1						" Allow strikethrough formatting in Markdown
let g:vim_markdown_new_list_item_indent = 0					" Keep same indent level when adding new list items
let g:vim_markdown_autowrite = 1							" Automatically save in the current document when following a link
let g:vim_markdown_edit_url_in = 'tab'						" Open links in a new tab and not the current buffer
let g:vim_markdown_follow_anchor = 1						" Allows ge command to follow named anchors in links in the form of file#anchor


" SET THEME
if has('nvim')
	colorscheme gruvbox
endif


" KEY BINDINGS
set backspace=indent,eol,start								" Make backspace behave more intuitively
nnoremap <SPACE> <Nop>										" Remap Leader key
let mapleader=" "
nmap Q <Nop>												" Q in normal mode enters Ex mode
nnoremap <leader>w :w<CR>									" <Space>w saves file
nnoremap Y y$												" Map Y to yank to EOL like D and C
nnoremap <leader>h :nohl<CR>								" <Space>h turns off search highlighing
nnoremap <C-L> :nohl<CR><C-L>								" <C-L> redraws the screens and turns off search highlighting
nnoremap J 10j												" Map J and K to 10j and 10k respectively
nnoremap K 10k
nnoremap <leader>j J										" Remap original join functionality to <Space>j
nnoremap <C-n> :NERDTreeFocus<CR>							" Go to NERDTree
nnoremap <leader>n :NERDTreeMirror<CR>:NERDTreeFocus<CR>	" Mirror NERDTree before showing it
nnoremap <leader>t :NERDTreeToggle<CR>						" Toggle NERDTree
" nnoremap <C-f> :NERDTreeFind<CR>							" Open NERDTree Finder
nnoremap <C-f> :Files<CR>									" FZF file finder
nnoremap <leader>f :Rg<CR>									" FZF rg find in file
