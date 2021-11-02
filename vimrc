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


" KEY BINDINGS
set backspace=indent,eol,start						" Make backspace behave more intuitively
nnoremap <SPACE> <Nop>								" Remap Leader key
let mapleader=" "
nmap Q <Nop>										" Q in normal mode enters Ex mode
nnoremap <leader>h :nohl<CR>						" <Space>h turns off search highlighing
nnoremap <C-L> :nohl<CR><C-L>						" <C-L> redraws the screens and turns off search highlighting
nnoremap J 10j										" Map J and K to 10j and 10k respectively
nnoremap K 10k
nnoremap <leader>j J								" Remap original join functionality to <Space>j
nnoremap Y y$										" Map Y to yank to EOL like D and C


" PLUGINS
call plug#begin('./vim/plugged')
" Plugins listed in alphabetical order by repository name
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-repeat'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
" Themes
Plug 'dracula/vim',{'as':'dracula'}
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'sainnhe/sonokai'
call plug#end()


" PLUGIN SETTINGS
let g:NERDSpaceDelims = 1							" Add spaces after comment delimiters by default
let g:NERDCommentEmptyLines = 1						" Allow commenting and inverting empty lines


" SET THEME
if has('nvim')
	colorscheme gruvbox
endif
