" MOST IMPORTANT SETTINGS

" Best practice to set this explictly at the top of .vimrc
" Switches from default vi-compatibility mode and enables Vim functionality
set nocompatible
" Disable Vim startup message
set shortmess+=I
" Set visual bell instead of audible bell
set visualbell
set t_vb=
" Enable mouse support for all modes
if has('mouse')
  set mouse=a
endif
" Allow hidden buffers
set hidden
" Ask to save changed files
set confirm
" Set encoding to UTF-8
if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif


" FORMATTING 

" Always show status line at the bottom
set laststatus=2
" Show empty line at the bottom
if !&scrolloff
  set scrolloff=8
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline
" Enable syntax highlighting
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif
" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif
" Line numbers
set number
set relativenumber
set ruler
" Setting basic listchars
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j 
endif


" COMMANDS

" Better command-line completion
set wildmenu
" Show partial commands in last line of screen
set showcmd
set complete-=i
" Stop certain movements from going to the first character of a line
set nostartofline
set nrformats-=octal
" Never time out on mappings, quickly time out on keycodes
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif


" INDENTING

" Enable intelligent auto-indenting based on file type
if has('autocmd')
  filetype indent plugin on
endif
" Keep same indent as previous line when opening new line
set autoindent
set smarttab
" Set indentation width for tabs
set shiftwidth=4
set tabstop=4


" SEARCHING

set ignorecase		" Case-insensitive searching
set smartcase		" Case-sensitive searching if search contains any capital letters
set incsearch		" Allow searching as you type
set hlsearch		" Highlight searches


" KEY BINDINGS

" Make backspace behave more intuitively
set backspace=indent,eol,start
" Remap Leader key
nnoremap <SPACE> <Nop>
let mapleader=" "
" Recursive Mappings
nmap Q <Nop>			" Q in normal mode enters Ex mode
" Non-recursive Mappings
nnoremap Y y$			" Map Y to yank to EOL like D and C
nnoremap <leader>h :nohl<CR>	" <Space>h turns off search highlighing
nnoremap <C-L> :nohl<CR><C-L>	" <C-L> redraws the screens and turns off search highlighting
