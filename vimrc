" vim: sw=2
" Localization
language messages C
set langmenu=none       " use English menus
set encoding=utf-8      " default encoding
set fileencodings=utf-8,cp1251,koi8-r,cp866 " automatically detected character encodings
set spelllang=en,ru     " list of accepted languages

" Display options
set title               " show info in the window title
set listchars=eol:$,tab:>-,trail:-,precedes:<,extends:>  "list of strings used for list mode
set listchars=eol:¬,tab:▸\ ,trail:·,precedes:«,extends:» "list of strings used for list mode
set fillchars=fold:-,vert:\| " fill chars
set fillchars=fold:-,vert:\│ " fill chars
set vb noeb t_vb=       " disable beep and flash
set showcmd             " show (partial) command keys in the status line
set scrolloff=2         " number of screen lines to show around the cursor
set sidescroll=4        " minimal number of columns to scroll horizontally
set sidescrolloff=10    " minimal number of columns to keep left and right of the cursor
set laststatus=2        " always show status line
set statusline=%<%f\ %h%m%r%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\",\".&ff.\"]\ \"}%=%-14.(%l,%c%V%)\ %P
set ruler               " show the cursor position all the time
set wildmenu            " command line completion shows a list of matches
set confirm             " start a dialog when a command fails
set noshowmode          " dont show mode in the last line
set diffopt=filler,vertical " vertical diff by default
let &showbreak = '↳ '
set breakindent
set breakindentopt=sbr
set completeopt-=preview

" Tabs and indenting
set autoindent          " copy indent from previous line
set smartindent         " enable nice indent
set expandtab           " tab with spaces
set smarttab            " indent using shiftwidth
set shiftwidth=4        " number of spaces to use for each step of indent
set softtabstop=4       " tab like 4 spaces
set shiftround          " round indent to shiftwidth

" Search options
set hlsearch            " highlight all matches for the last used search pattern
set incsearch           " do incremental searching
set ignorecase          " ignore case when using a search pattern
set smartcase           " override 'ignorecase' when pattern has upper case characters

" Buffer options
set hidden              " don't unload a buffer when no longer shown in a window
set autoread            " Auto read changed outside of vim files

" Edit
set backspace=indent,eol,start " allow backspacing over everything in insert mode

" Windows
set splitbelow
set splitright

" X-clipboard
if has('unnamedplus')
  if has('nvim')
    set clipboard+=unnamedplus
  else
    set clipboard=autoselect,unnamed,unnamedplus,exclude:cons\|linux
  endif
endif

set history=50          " keep 50 lines of command line history
set pastetoggle=        " key sequence to toggle paste mode

" backups, swapfiles, & undofiles in one place
let s:myvimdir ="~/.vim"
let s:tempdir=expand(s:myvimdir."/tmp")
if !isdirectory(expand(s:tempdir))
  call mkdir(expand(s:tempdir), "p")
endif
set backup
let &backupdir=s:tempdir
set swapfile
let &directory=s:tempdir
if has('persistent_undo')
  set undofile
  let &undodir=s:tempdir
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
  set mousemodel=popup_setpos " what the right mouse button is used for
endif
if !has('nvim')
  if has("mouse_sgr")
    set ttymouse=sgr
  else
    set ttymouse=xterm2
  endif
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Enable true color
if &term =~# '^tmux-256color\|^xterm-256color\|^screen-256color'
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

if has("gui_running")
  set guioptions-=T " no toolbar
  set guioptions-=t " no tearoff menu items
  set guioptions-=m " no menu bar
  set guioptions-=r " no right scrollbar
  set guioptions-=L " no left scrollbar
  set guioptions-=e " no gui tabs
  set guioptions+=c " use console dialog for simple choices

  if has('gui_win32')
    set guifont=Ubuntu_Mono:h12:cRUSSIAN:qDRAFT,Consolas:h11:cRUSSIAN
  elseif has ('gui_gtk3')
    set guifont=Hack\ 10,Ubuntu\ Mono\ 12,Droid\ Sans\ Mono\ 10
  endif
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
  "au InsertEnter * set cursorline
  "au InsertLeave * set nocursorline

  " Auto close preview window
  "au CursorMovedI * if pumvisible() == 0|pclose|endif
  "au InsertLeave * if pumvisible() == 0|pclose|endif

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " For vim config files
  autocmd FileType vim setlocal shiftwidth=2 softtabstop=2

  " IP tables
  autocmd BufNewFile,BufRead * if getline(1) =~ "^# Generated by iptables" | set ft=iptables | endif

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  autocmd ColorScheme *
    \ highlight SignColumn ctermbg=NONE guibg=NONE |
    \ highlight LineNr ctermbg=NONE guibg=NONE |
    \ highlight SignifySignAdd    ctermbg=NONE guibg=NONE ctermfg=119 guifg=#A6E22E |
    \ highlight SignifySignDelete ctermbg=NONE guibg=NONE ctermfg=167 guifg=#F92672 |
    \ highlight SignifySignChange ctermbg=NONE guibg=NONE ctermfg=227 guifg=#E6DB74
  augroup END
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                  \ | wincmd p | diffthis
endif


" Mapping
nnoremap <Space> <Nop>
let mapleader = " "

" Use Enter for command line
nnoremap <CR> :

" Change current working directory
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Toggle paste mode
nnoremap <silent> <Leader>p :set paste!<CR>:set paste?<CR>

" Not jump on star, only highlight
nnoremap * *N

" Drop highlight search result
noremap <Leader><Space> :nohls<CR>

" Toggle spell
nnoremap <silent> <Leader>os :set spell!<CR>:set spell?<CR>

" Tabs
nnoremap gb gT
nnoremap <Leader>tc :tabnew<CR>
nnoremap <Leader>tx :tabclose<CR>

" Toggle wrap mode
noremap <silent> <Leader>w :set wrap!<CR>:set wrap?<CR>

" Toggle list mode
noremap <silent> <Leader>l :set list!<CR>:set list?<CR>

" Toggle numbers
noremap <silent> <Leader>n :set number!<CR>:set number?<CR>

" Toggle relative numbers
noremap <silent> <Leader>r :set relativenumber!<CR>:set relativenumber?<CR>

" Toggle crosshair
nnoremap <silent> <Leader>x :set cursorline!<CR>:set cursorcolumn!<CR>

nnoremap <silent> <Leader>ob :let &background = (&background == "dark" ? "light": "dark")<CR>:set background?<CR>

" Write file
map <F2> :w<CR>
map <Leader><F2> :w !sudo tee %<CR>

" Quit
map <F3> :q<CR>
map <Leader><F3> :q!<CR>

" Quickfix and location navigation
map <silent> ]q :cnext<CR>
map <silent> [q :cprev<CR>
map <silent> ]l :lnext<CR>
map <silent> [l :lprev<CR>

" Make
"map <F5> :make<CR>

if has('win32') || has('win64')
  " use ~/.vim on windows
  set runtimepath^=~/.vim
endif

" Plugins
let vim_plug_dir = '~/.vim/autoload/plug.vim'
if empty(glob(vim_plug_dir))
  execute '!curl -fLo ' . expand(vim_plug_dir) . ' --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/bundle')
" VCS
Plug 'tpope/vim-fugitive'
  nnoremap <silent> <Leader>gs :belowright Gstatus<CR>
  nnoremap <silent> <Leader>gd :Gdiff<CR>

" Editing
Plug 'scrooloose/nerdcommenter'
Plug 'coderifous/textobj-word-column.vim'
Plug 'takac/vim-hardtime'
  let g:hardtime_default_on = 0
Plug 'junegunn/vim-easy-align'
  xmap ga <Plug>(EasyAlign)
  nmap ga <Plug>(EasyAlign)
Plug 'machakann/vim-sandwich'
  let g:sandwich_no_default_key_mappings = 1
  let g:operator_sandwich_no_default_key_mappings = 1
  silent! nmap <unique> csa <Plug>(operator-sandwich-add)
  silent! xmap <unique> csa <Plug>(operator-sandwich-add)
  silent! omap <unique> csa <Plug>(operator-sandwich-g@)
  silent! xmap <unique> csd <Plug>(operator-sandwich-delete)
  silent! xmap <unique> csr <Plug>(operator-sandwich-replace)
  silent! nmap <unique><silent> csd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
  silent! nmap <unique><silent> csr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
  silent! nmap <unique><silent> csdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
  silent! nmap <unique><silent> csrb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
Plug 'AndrewRadev/switch.vim'
  let g:switch_mapping = ""
  nmap <silent> <leader>t :call switch#Switch()<CR>
  let g:switch_custom_definitions = 
        \ [
        \   [ 'yes', 'no' ],
        \   [ 'YES', 'NO' ],
        \   [ 'Yes', 'No' ],
        \   [ 'TRUE', 'FALSE' ]
        \ ]
Plug 'tmsvg/pear-tree'
Plug 'justinmk/vim-sneak'
  let g:sneak#label = 1
  " 2-character Sneak (default)
  nmap s <Plug>Sneak_s
  nmap S <Plug>Sneak_S
  " visual-mode
  xmap s <Plug>Sneak_s
  xmap S <Plug>Sneak_S
  " operator-pending-mode
  omap s <Plug>Sneak_s
  omap S <Plug>Sneak_S
  
" Files and searching
Plug 'justinmk/vim-gtfo'
Plug 'ctrlpvim/ctrlp.vim'
  let g:ctrlp_switch_buffer = 'et'
  if executable('rg')
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
    let g:ctrlp_use_caching = 0
  elseif executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    let g:ctrlp_use_caching = 0
  endif
Plug 'mileszs/ack.vim'
  if executable('rg')
    let g:ackprg = 'rg --vimgrep --no-heading'
  elseif executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif
  nnoremap <Leader>aa :Ack<Space>
  nnoremap <Leader>af :AckFile<Space>
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind']}
  let NERDTreeMinimalUI = 1
  let NERDTreeNaturalSort = 1
  let NERDTreeIgnore = ['\~$', ',cover$', '__pycache__']
  noremap <silent> <Leader>f :NERDTreeToggle<CR>
  ounmap <Leader>f
  noremap <silent> <leader>gf :NERDTreeFind<CR>

" Interface
Plug 'junegunn/vim-peekaboo'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'jlanzarotta/bufexplorer'
    let g:bufExplorerDefaultHelp = 0
    let g:bufExplorerFindActive = 0
    let g:bufExplorerShowRelativePath=1
Plug 'mhinz/vim-signify'
  let g:signify_vcs_list = [ 'git', 'hg' ]
  let g:signify_realtime = 1
  let g:signify_cursorhold_normal = 0
  let g:signify_cursorhold_insert = 0
  let g:signify_sign_add = '+'
  let g:signify_sign_delete = 'x'
  let g:signify_sign_delete_first_line = 'x'
  let g:signify_sign_change = '•'
  let g:signify_sign_changedelete = g:signify_sign_change
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
  let g:tagbar_autofocus = 1
  let g:tagbar_autoclose = 1
  let g:tagbar_compact = 1
  let g:tagbar_foldlevel = 0
  nnoremap <silent> <F9> :TagbarToggle<CR>
Plug 'Yggdroot/indentLine'
  let g:indentLine_enabled = 0
  nnoremap <silent> <Leader>I :IndentLinesToggle<CR>
Plug 'junegunn/rainbow_parentheses.vim'
  let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
Plug 'milkypostman/vim-togglelist'
  let g:toggle_list_no_mappings = 1
  nmap <silent> <leader>wl :call ToggleLocationList()<CR>
  nmap <silent> <leader>wq :call ToggleQuickfixList()<CR>

" Filetypes
Plug 'skarrok/vim-hcl'
  autocmd FileType hcl setlocal foldlevel=999 foldmethod=syntax
Plug 'sheerun/vim-polyglot'
  let g:polyglot_disabled = ['hcl']
Plug 'vim-scripts/iptables'

" Linting, snippets and completion
Plug 'dense-analysis/ale'
  "let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'python': ['black', 'isort'],
    \ 'javascript': ['eslint', 'prettier_standard'],
  \ }
  let g:ale_linter_aliases = {
    \ 'vue': ['vue', 'javascript'],
  \ }
  let g:ale_linters = {
    \ 'python': ['flake8'],
    \ 'javascript': ['eslint'],
    \ 'vue': ['eslint', 'vls'],
  \ }
  "let g:ale_python_flake8_options = '--extend-ignore=W503 --max-line-length=99 --max-complexity 15'
  "let g:ale_python_isort_options = '--combine-as --order-by-type --trailing-comma --use-parentheses --multi-line 3'
  "let g:ale_python_black_options = '--line-length 88 --skip-string-normalization'
  let g:ale_sign_error = '»»'
  "let g:ale_sign_warning = '≈≈'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
  " yarn global add bash-language-server
  " yarn global add vim-language-server
  " yarn global add vscode-css-languageserver-bin
  " yarn global add dockerfile-language-server-nodejs
  " yarn global add typescript-language-server
  " yarn global add vue-language-server
  " pip install python-language-server
  let g:lsp_diagnostics_enabled = 0
  let g:lsp_highlight_references_enabled = 1
  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    nmap <silent><buffer> gd <plug>(lsp-definition)
    nmap <silent><buffer> <Leader>gr <plug>(lsp-references)
    nmap <silent><buffer> K <plug>(lsp-hover)
    nmap <silent><buffer> <c-k> <plug>
  endfunction
  augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
  let g:asyncomplete_remove_duplicates = 1
  imap <c-space> <Plug>(asyncomplete_force_refresh)
  inoremap <expr> <C-y> pumvisible() ? "\<C-e>\<C-y>" : "\<C-y>"
  inoremap <expr> <C-e> pumvisible() ? "\<C-e>\<C-e>" : "\<C-e>"
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
Plug 'prabirshrestha/asyncomplete-lsp.vim'

if has('python3')
Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
endif
    

" Colors
Plug 'itchyny/lightline.vim'
  if &t_Co == 256 || has('gui_running')
    let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ]],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'gitbranch', 'fileformat', 'fileencoding', 'filetype' ] ],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \ },
      \ }
  endif
Plug 'vim-scripts/xoria256.vim'
Plug 'crusoexia/vim-monokai'
Plug 'tomasr/molokai'
  let g:rehash256 = 1
Plug 'fmoralesc/molokayo'
Plug 'morhetz/gruvbox'
  let g:gruvbox_contrast_dark = 'medium'
  let g:gruvbox_contrast_light = 'soft'
Plug 'sjl/badwolf'
Plug 'iCyMind/NeoSolarized'
Plug 'joshdick/onedark.vim'
call plug#end()

try
  call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
      \ 'name': 'ultisnips',
      \ 'whitelist': ['*'],
      \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
      \ }))
catch
endtry

try " catch all on first run without installed plugins
  if &t_Co == 256 || has('gui_running')
    set background=dark
    colorscheme gruvbox
  endif
catch 
endtry
