" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Buffer options
set hidden              " hide buffers when they abandoned

" Display options
set title               " show file name in window title
set listchars=eol:$,tab:>-,trail:-,precedes:<,extends:>
set vb noeb t_vb=       " disable beep and flash
set showcmd             " display incomplete commands
set scrolloff=2         " number of screen lines to show around the cursor
set sidescroll=4
set sidescrolloff=10
set statusline=%<%f\ %h%m%r%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\",\".&ff.\"]\ \"}%=%-14.(%l,%c%V%)\ %P
set laststatus=2        " always show status line
set ruler               " show the cursor position all the time
set wildmenu            " command line completion shows a list of matches
set confirm

" Localization
language messages C
set langmenu=none       " use English menus
set encoding=utf-8      " default encoding
set fileencodings=utf-8,cp1251,koi8-r,cp866
set spelllang=en,ru

" Tab options
set autoindent          " copy indent from previous line
set smartindent         " enable nice indent
set expandtab           " tab with spaces
set smarttab            " indent using shiftwidth
set shiftwidth=4        " number of spaces to use for each step of indent
set softtabstop=4       " tab like 4 spaces
set shiftround          " round indent to shiftwidth

" Search options
set hlsearch            " highlight search results
set incsearch           " do incremental searching
set ignorecase          " ignore case when using a search pattern
set smartcase           " override 'ignorecase' when pattern has upper case characters

" Edit
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" X-clipboard
if has('unnamedplus')
  set clipboard+=unnamed
endif

set backup              " keep a backup file
set history=50          " keep 50 lines of command line history
set pastetoggle=        " key sequence to toggle paste mode

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if has("gui_running")
  colorscheme desert
else
  colorscheme koehler
endif

" Only do this part when compiled with support for auto commands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!
  
  " Auto reload vim settings
  au! BufWritePost *.vimrc source ~/.vimrc

  " Highlight current line in insert mode
  au InsertEnter * set cursorline
  au InsertLeave * set nocursorline

  " Auto close preview window
  "au CursorMovedI * if pumvisible() == 0|pclose|endif
  "au InsertLeave * if pumvisible() == 0|pclose|endif

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent                " always set auto indenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                  \ | wincmd p | diffthis
endif


" Mapping
let mapleader = "\\"

" Toggle paste mode
nnoremap <silent> <Leader>p :set paste!<CR>:set paste?<CR>

" Not jump on star, only highlight
nnoremap * *N

" Drop highlight search result
noremap <Leader><Space> :nohls<CR>

" Toggle spell
nnoremap <silent> <Leader>s :set spell!<CR>:set spell?<CR>

" Tabs
nnoremap <Leader>tn :tabnew<CR>
nnoremap <Leader>tc :tabc<CR>

" Toggle wrap mode
noremap <silent> <Leader>w :set wrap!<CR>:set wrap?<CR>

" Toggle list mode
noremap <silent> <Leader>l :set list!<CR>:set list?<CR>

" Toggle numbers
noremap <silent> <Leader>n :set number!<CR>:set number?<CR>

" Write file
map <F2> :w<CR>

" Vundle
let vundle_dir = expand('~/.vim/bundle/vundle')
if isdirectory(vundle_dir) " check if dir exist
  filetype off
  exe "set rtp+=".vundle_dir
  call vundle#rc()
  Bundle 'gmarik/vundle'

  " Bundles
  Bundle 'toggle_word.vim'
  Bundle 'The-NERD-Commenter'
  Bundle 'The-NERD-tree'
    noremap <silent> <Leader>f :NERDTreeToggle<CR>
    ounmap <Leader>f

  Bundle 'xoria256.vim'
  Bundle 'altercation/vim-colors-solarized'
    call togglebg#map("<F5>")
    if has('gui_running')
        set background=light
        colorscheme solarized
    endif

  filetype plugin indent on
endif

