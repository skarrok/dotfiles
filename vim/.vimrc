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
set listchars=eol:¬,tab:▸\ ,trail:·,precedes:«,extends:»,space:⋅ "list of strings used for list mode
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
set foldlevelstart=999

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
if $TERM =~# '^tmux-256color\|^xterm-256color\|^screen-256color'
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
  " Auto reload vim settings
  autocmd BufWritePost *.vimrc source ~/.vimrc

  autocmd BufNewFile,BufRead *.go setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab

  " IP tables
  autocmd BufNewFile,BufRead * if getline(1) =~ "^# Generated by iptables" | set ft=iptables | endif

  " higlight yanked text
  if has("nvim")
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=100, on_visual=true})
  endif

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
    \ highlight SignifySignChange ctermbg=NONE guibg=NONE ctermfg=227 guifg=#E6DB74 |
    \ highlight GitSignsAdd    ctermbg=NONE guibg=NONE ctermfg=119 guifg=#A6E22E |
    \ highlight GitSignsDelete ctermbg=NONE guibg=NONE ctermfg=167 guifg=#F92672 |
    \ highlight GitSignsChange ctermbg=NONE guibg=NONE ctermfg=227 guifg=#E6DB74
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
let maplocalleader = " "

" Use Enter for command line
nnoremap <CR> :

" Change current working directory
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Not jump on star, only highlight
nnoremap * *N

" Drop highlight search result
nnoremap <Leader><Space> :nohls<CR>

" Paste/Replace without overwiting default register
xnoremap <Leader>p "_dP

" Prefill replace with current word
nnoremap <Leader>ss :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Tabs
nnoremap gb gT
nnoremap <silent> <Leader>tc :tabnew<CR>
nnoremap <silent> <Leader>tx :tabclose<CR>

" Windows
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Toggle some options
nnoremap <silent> <Leader>op :set paste!<CR>:set paste?<CR>
nnoremap <silent> <Leader>os :set spell!<CR>:set spell?<CR>
nnoremap <silent> <Leader>ow :set wrap!<CR>:set wrap?<CR>
nnoremap <silent> <Leader>ol :set list!<CR>:set list?<CR>
nnoremap <silent> <Leader>on :set number!<CR>:set number?<CR>
nnoremap <silent> <Leader>or :set relativenumber!<CR>:set relativenumber?<CR>
nnoremap <silent> <Leader>ox :set cursorline!<CR>:set cursorcolumn!<CR>
nnoremap <silent> <Leader>ob :let &background = (&background == "dark" ? "light": "dark")<CR>:set background?<CR>
nnoremap <silent> <Leader>oc :let &colorcolumn = (&colorcolumn == 80 ? 0: 80)<CR>:echo "colorcolumn=".&colorcolumn<CR>
nnoremap <silent> <Leader>ot :highlight Normal guibg=None ctermbg=None<CR>

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

" Trigger InsertLeave on Control-C
inoremap <C-C> <Esc>
" see :h c_<Esc> for why this is neccessary
cnoremap <C-C> <C-C>

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
Plug 'junegunn/vim-plug'
Plug 'lambdalisue/suda.vim'
Plug 'christoomey/vim-tmux-navigator'
  let g:tmux_navigator_no_wrap = 1
  let g:tmux_navigator_no_mappings = 1
  tnoremap <silent> <A-h> <C-\><C-n>:TmuxNavigateLeft<CR>
  tnoremap <silent> <A-j> <C-\><C-n>:TmuxNavigateDown<CR>
  tnoremap <silent> <A-k> <C-\><C-n>:TmuxNavigateUp<CR>
  tnoremap <silent> <A-l> <C-\><C-n>:TmuxNavigateRight<CR>
  noremap <silent> <A-h> :<C-U>TmuxNavigateLeft<CR>
  noremap <silent> <A-j> :<C-U>TmuxNavigateDown<CR>
  noremap <silent> <A-k> :<C-U>TmuxNavigateUp<CR>
  noremap <silent> <A-l> :<C-U>TmuxNavigateRight<CR>
" VCS
Plug 'tpope/vim-fugitive'
  nnoremap <silent> <Leader>gs :belowright Git<CR>
  nnoremap <silent> <Leader>gd :Gdiff<CR>

" Editing
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-commentary'
Plug 'michaeljsmith/vim-indent-object'
Plug 'coderifous/textobj-word-column.vim'
Plug 'takac/vim-hardtime'
  let g:hardtime_default_on = 1
  let g:list_of_normal_keys = ["<Up>", "<Down>", "<Left>", "<Right>"]
  let g:list_of_visual_keys = ["<Up>", "<Down>", "<Left>", "<Right>"]
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
  nmap <silent> <leader>tt <Plug>(Switch)
  let g:switch_custom_definitions = 
        \ [
        \   [ 'on', 'off' ],
        \   [ 'ON', 'OFF' ],
        \   [ 'On', 'Off' ],
        \   [ 'yes', 'no' ],
        \   [ 'YES', 'NO' ],
        \   [ 'Yes', 'No' ],
        \   [ 'TRUE', 'FALSE' ]
        \ ]
Plug 'tmsvg/pear-tree'
  let g:pear_tree_repeatable_expand = 0
  let g:pear_tree_ft_disabled = ['TelescopePrompt']
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
if has('nvim')
  Plug 'kyazdani42/nvim-tree.lua'
    let g:loaded_netrwPlugin = 1
    let g:loaded_netrw = 1
    noremap <silent> <Leader>f :NvimTreeToggle<CR>
    ounmap <Leader>f
    noremap <silent> <leader>gf :NvimTreeFindFile!<CR>
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
    nnoremap <C-p> <cmd>Telescope find_files<CR>
    nnoremap <Leader>sa <cmd>Telescope live_grep<CR>
    nnoremap <Leader>sw <cmd>Telescope grep_string<CR>
    nnoremap <Leader>sl :Telescope lsp_<C-z>
    nnoremap z=  <cmd>Telescope spell_suggest theme=cursor<CR>
    nnoremap <Leader>sr <cmd>Telescope resume<CR>
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'nvim-telescope/telescope-ui-select.nvim'
else
  "Plug 'lambdalisue/fern.vim'
  "  let g:loaded_netrwPlugin = 1
  "  let g:loaded_netrw = 1
  "  noremap <silent> <Leader>f :Fern . -drawer -toggle<CR>
  "  ounmap <Leader>f
  "  noremap <silent> <leader>gf :Fern . -reveal=% -drawer<CR>
  Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind']}
    let NERDTreeMinimalUI = 1
    let NERDTreeNaturalSort = 1
    let NERDTreeIgnore = ['\~$', ',cover$', '__pycache__']
    noremap <silent> <Leader>f :NERDTreeToggle<CR>
    ounmap <Leader>f
    noremap <silent> <leader>gf :NERDTreeFind<CR>
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
endif

" Interface
Plug 'junegunn/vim-peekaboo'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'jlanzarotta/bufexplorer'
    let g:bufExplorerDefaultHelp = 0
    let g:bufExplorerFindActive = 0
    let g:bufExplorerShowRelativePath=1
if has('nvim')
  Plug 'lewis6991/gitsigns.nvim'
else
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
endif
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
  let g:tagbar_autofocus = 1
  let g:tagbar_autoclose = 1
  let g:tagbar_compact = 1
  let g:tagbar_foldlevel = 0
  let g:tagbar_type_go = {
          \ 'ctagstype' : 'go',
          \ 'kinds'     : [
                  \ 'p:package',
                  \ 'i:imports:1',
                  \ 'c:constants',
                  \ 'v:variables',
                  \ 't:types',
                  \ 'n:interfaces',
                  \ 'w:fields',
                  \ 'e:embedded',
                  \ 'm:methods',
                  \ 'r:constructor',
                  \ 'f:functions'
          \ ],
          \ 'sro' : '.',
          \ 'kind2scope' : {
                  \ 't' : 'ctype',
                  \ 'n' : 'ntype'
          \ },
          \ 'scope2kind' : {
                  \ 'ctype' : 't',
                  \ 'ntype' : 'n'
          \ },
          \ 'ctagsbin'  : 'gotags',
          \ 'ctagsargs' : '-sort -silent'
  \ }
  nnoremap <silent> <F9> :TagbarToggle<CR>
if has('nvim')
  Plug 'lukas-reineke/indent-blankline.nvim', { 'on': 'IndentBlanklineToggle' }
    let g:indent_blankline_enabled = v:false
    nnoremap <silent> <Leader>I :IndentBlanklineToggle<CR>
else
  Plug 'Yggdroot/indentLine'
    let g:indentLine_enabled = 0
    nnoremap <silent> <Leader>I :IndentLinesToggle<CR>
end
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
  let g:polyglot_disabled = ['sensible', 'hcl', 'jsx']
  let g:vue_pre_processors = []
Plug 'vim-scripts/iptables'

" Linting, snippets and completion
Plug 'hrsh7th/vim-vsnip'
  " Expand
  imap <expr> <Tab> vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<Tab>'
  smap <expr> <Tab> vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<Tab>'
  " Expand or jump
  imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
  smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
  " Jump forward or backward
  imap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)'      : '<C-j>'
  smap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)'      : '<C-j>'
  imap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)'      : '<C-k>'
  smap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)'      : '<C-k>'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
if has('nvim')
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
  Plug 'folke/lsp-colors.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'folke/trouble.nvim'
    nmap <silent> <Leader>wt <cmd>TroubleToggle<CR>
  Plug 'mfussenegger/nvim-dap'
  Plug 'leoluz/nvim-dap-go'
  Plug 'rcarriga/nvim-dap-ui'
  Plug 'jose-elias-alvarez/null-ls.nvim'
  Plug 'simrat39/rust-tools.nvim'
  Plug 'j-hui/fidget.nvim'
  nmap <silent> <F8> <cmd>lua vim.lsp.buf.format({async=true})<CR>
  sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
  sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=
  sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
  sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
else
  Plug 'dense-analysis/ale'
    "let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
    let g:ale_disable_lsp = 1
    let g:ale_virtualtext_cursor = 1
    nmap <silent> <F8> <Plug>(ale_fix)
    let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'python': ['autoimport', 'isort', 'black'],
      \ 'javascript': ['eslint', 'prettier'],
      \ 'vue': ['eslint', 'prettier'],
      \ 'go': ['gofmt'],
    \ }
    let g:ale_linter_aliases = {
      \ 'vue': ['vue', 'javascript'],
    \ }
    let g:ale_linters = {
      \ 'python': ['flake8'],
      \ 'javascript': ['eslint', 'prettier'],
      \ 'vue': ['eslint', 'prettier', 'vls'],
    \ }
    "let g:ale_python_flake8_options = '--extend-ignore=W503 --max-line-length=99 --max-complexity 15'
    "let g:ale_python_isort_options = '--combine-as --order-by-type --trailing-comma --use-parentheses --multi-line 3'
    "let g:ale_python_black_options = '--line-length 88 --skip-string-normalization'
    let g:ale_sign_error = '»»'
    "let g:ale_sign_warning = '≈≈'
  Plug 'ryanoasis/vim-devicons'
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
    let g:lsp_document_highlight_enabled = 1
    let g:lsp_document_code_action_signs_enabled = 0
    function! s:on_lsp_buffer_enabled() abort
      setlocal omnifunc=lsp#complete
      nmap <silent><buffer> gd <plug>(lsp-definition)
      nmap <silent><buffer> gs <plug>(lsp-document-symbol-search)
      nmap <silent><buffer> gS <plug>(lsp-workspace-symbol-search)
      nmap <silent><buffer> gr <plug>(lsp-references)
      nmap <silent><buffer> <Leader>gi <plug>(lsp-implementation)
      nmap <silent><buffer> <Leader>gt <plug>(lsp-type-definition)
      nmap <silent><buffer> K <plug>(lsp-hover)
      "inoremap <buffer> <expr><c-f> lsp#scroll(+4)
      "inoremap <buffer> <expr><c-d> lsp#scroll(-4)

      let g:lsp_format_sync_timeout = 1000
    endfunction
    augroup lsp_install
      au!
      autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
      autocmd BufWritePre *.go call execute('LspDocumentFormatSync')
      "autocmd FileType python setlocal
      "      \ foldmethod=expr
      "      \ foldexpr=lsp#ui#vim#folding#foldexpr()
      "      \ foldtext=lsp#ui#vim#folding#foldtext()
    augroup END
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/asyncomplete.vim'
    let g:asyncomplete_remove_duplicates = 1
    imap <c-space> <Plug>(asyncomplete_force_refresh)
    "inoremap <expr> <C-y> pumvisible() ? "\<C-e>\<C-y>" : "\<C-y>"
    "inoremap <expr> <C-e> pumvisible() ? "\<C-e>\<C-e>" : "\<C-e>"
    inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : "\<CR>"
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
endif

" Colors
Plug 'itchyny/lightline.vim'
  function! s:set_lightline_colorscheme(name) abort
    let g:lightline.colorscheme = a:name
    execute 'source' globpath(&rtp, "autoload/lightline/colorscheme/".a:name.".vim")
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
  endfunction

  function! s:lightline_colorschemes(...) abort
    return join(map(
          \ globpath(&rtp, "autoload/lightline/colorscheme/*.vim",1,1),
          \ "fnamemodify(v:val,':t:r')"),
          \ "\n")
  endfunction
  command! -nargs=1 -complete=custom,s:lightline_colorschemes LightlineColorscheme
        \ call s:set_lightline_colorscheme(<q-args>)
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
Plug 'gruvbox-community/gruvbox'
  let g:gruvbox_contrast_dark = 'medium'
  let g:gruvbox_contrast_light = 'medium'
  let g:gruvbox_sign_column = 'none'
Plug 'sjl/badwolf'
Plug 'iCyMind/NeoSolarized'
Plug 'joshdick/onedark.vim'
call plug#end()

" Setup nvim lua plugins
if has('nvim') && exists('plugs')
if has_key(plugs, 'gitsigns.nvim')
lua << EOF
  require("nvim-tree").setup({
    filters = {
      dotfiles = true,
    },
    git = {
      enable = false,
    },
  })
  require('gitsigns').setup{
    attach_to_untracked = false,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true})
    end
  }
EOF
endif

if has_key(plugs, 'telescope.nvim')
lua << EOF
  -- require("telescope").setup{
  --   pickers = {
  --     find_files = {
  --       find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
  --     },
  --   }
  -- }
  require('telescope').setup({
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_cursor {}
      }
    }
  })
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('ui-select')
EOF
endif

if has_key(plugs, 'nvim-treesitter')
lua << EOF
  require('nvim-treesitter.configs').setup({
    highlight = {
      enable = true,
      disable = { "vim" }
    } 
  })
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
EOF
endif

if has_key(plugs, 'mason.nvim') && has_key(plugs, 'mason-lspconfig.nvim')
lua << EOF
  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = { "bashls", "dockerls", "jsonls", "marksman", "sqlls", "vimls", "yamlls", "lua_ls", "pyright" }
  })
EOF
endif

if has_key(plugs, 'null-ls.nvim')
lua << EOF
  local h = require("null-ls.helpers")
  local methods = require("null-ls.methods")
  local FORMATTING = methods.internal.FORMATTING
  local autoimport = h.make_builtin({
      name = "autoimport",
      meta = {
          url = "https://lyz-code.github.io/autoimport/",
          description = "Autoimport missing python libraries",
      },
      method = FORMATTING,
      filetypes = { "python" },
      generator_opts = {
          command = "autoimport",
          args = {
              "-",
          },
          to_stdin = true,
      },
      factory = h.formatter_factory,
  })
  require("null-ls").setup({
    temp_dir = "/tmp",
    sources = {
        autoimport.with({ prefer_local = ".venv/bin" }),
        require("null-ls").builtins.formatting.isort.with({ prefer_local = ".venv/bin" }),
        require("null-ls").builtins.formatting.black.with({ prefer_local = ".venv/bin" }),
        require("null-ls").builtins.diagnostics.mypy.with({ prefer_local = ".venv/bin" }),
        require("null-ls").builtins.diagnostics.flake8.with({
          extra_args = {'--extend-ignore=BLK'},
          prefer_local = ".venv/bin",
        }),
        require("null-ls").builtins.code_actions.gitsigns,
        require("null-ls").builtins.formatting.golines.with({ extra_args = {"-m", "88", "-t", "4"} }),
        require("null-ls").builtins.diagnostics.golangci_lint,
        require("null-ls").builtins.code_actions.gomodifytags,
        require("null-ls").builtins.formatting.sql_formatter,
    },
  })
EOF
endif

if has_key(plugs, 'nvim-lspconfig') && has_key(plugs, 'nvim-cmp')
lua << EOF
  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)

  function diagnostic_toggle_virtual_text(global)
    local vars, bufnr, cmd
    if global then
      vars = vim.g
      bufnr = nil
    else
      vars = vim.b
      bufnr = 0
    end
    vars.diagnosics_virtual_text = not vars.diagnosics_virtual_text
    vim.diagnostic.show(nil, bufnr, nil, {virtual_text = vars.diagnosics_virtual_text})
  end
  vim.keymap.set('n', '<Leader>odl', diagnostic_toggle_virtual_text, {noremap = true, silent = true, buffer=bufnr})

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wl', function()
    --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, bufopts)
    vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<Leader>cr', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<Leader>cf', function() vim.lsp.buf.format { async = true } end, bufopts)
  end

  local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
  }
  local cmp = require'cmp'
  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'nvim_lsp_signature_help' },
    }, {
      { name = 'buffer', keyword_length = 3 },
    })
  })

  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  require('lspconfig')['pyright'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    handlers = {
      ['textDocument/publishDiagnostics'] = function() end
    }
  }
  require('lspconfig')['bashls'].setup { on_attach = on_attach, flags = lsp_flags, capabilities = capabilities }
  require('lspconfig')['dockerls'].setup { on_attach = on_attach, flags = lsp_flags, capabilities = capabilities }
  require('lspconfig')['jsonls'].setup { on_attach = on_attach, flags = lsp_flags, capabilities = capabilities }
  require('lspconfig')['marksman'].setup { on_attach = on_attach, flags = lsp_flags, capabilities = capabilities }
  require('lspconfig')['sqlls'].setup { on_attach = on_attach, flags = lsp_flags, capabilities = capabilities }
  require('lspconfig')['vimls'].setup { on_attach = on_attach, flags = lsp_flags, capabilities = capabilities }
  require('lspconfig')['lua_ls'].setup { on_attach = on_attach, flags = lsp_flags, capabilities = capabilities }
  require('lspconfig')['gopls'].setup{ on_attach = on_attach, flags = lsp_flags, capabilities = capabilities }
  require('lspconfig')['yamlls'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
      yaml = {
        keyOrdering = false
      }
    }
  }
  -- require('lspconfig')['rust_analyzer'].setup{
  --   on_attach = on_attach,
  --   flags = lsp_flags,
  --   capabilities = capabilities,
  --   settings = {
  --     ["rust-analyzer"] = {}
  --   }
  -- }
  local rt = require("rust-tools")

  rt.setup({
    tools = {
      runnables = {
        use_telescope = true,
      },
      inlay_hints = {
        auto = true,
        show_parameter_hints = true,
      }
    },
    server = {
      on_attach = on_attach,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          }
        }
      }
    }
  })
EOF
endif

if has_key(plugs, 'nvim-dap')
lua << EOF
  require('dap-go').setup()
  require("dapui").setup()
  vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
  vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
  vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
  vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
  vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
  vim.keymap.set('n', '<Leader>du', function() require('dapui').toggle() end)
  vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
EOF
endif
endif

try " catch all on first run without installed plugins
  if &t_Co == 256 || has('gui_running')
    set background=dark
    colorscheme gruvbox
  endif
catch 
endtry
