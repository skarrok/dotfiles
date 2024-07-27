vim.cmd.language("messages C")

local opt = vim.opt

opt.langmenu = "none" -- use English menus
opt.fileencodings = { "utf-8", "cp1251", "koi8-r", "cp866" } -- automatically detected character encodings
opt.spelllang = { "en", "ru" } -- list of accepted languages

-- Display options
opt.title = true -- show info in the window title
opt.listchars = { eol = "$", tab = ">-", trail = "-", precedes = "<", extends = ">" }
opt.listchars =
  { eol = "¬", tab = "⇥ ", trail = "␣", precedes = "«", extends = "»", space = "⋅", nbsp = "⍽" }
-- vim.opt.listchars = { tab = "⇥ ", leadmultispace = "┊ ", trail = "␣", nbsp = "⍽" }
-- opt.fillchars = { fold = "-", vert = "|" }
-- opt.fillchars = { fold = "-", vert = "│" }
opt.statusline =
  [[%<%f %h%m%r%{"[".(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?",B":"").",".&ff."] "}%=%-14.(%l,%c%V%) %P]]
opt.visualbell = false -- disable beep and flash
opt.errorbells = false -- disable beep and flash
opt.showcmd = true -- show (partial) command keys in the status line
opt.scrolloff = 2 -- number of screen lines to show around the cursor
opt.sidescroll = 4 -- minimal number of columns to scroll horizontally
opt.sidescrolloff = 10 -- minimal number of columns to keep left and right of the cursor
opt.laststatus = 2 -- always show status line
opt.showtabline = 1 -- show tabline if there are multiple tabs
opt.ruler = true -- show the cursor position all the time
opt.wildmenu = true -- command-line completion shows a list of matches
opt.confirm = true -- start a dialog when a command fails
opt.showmode = false -- dont show mode in the last line
opt.diffopt = { "filler", "vertical" } -- vertical diff by default
opt.showbreak = "↳ " -- string to put at the start of lines that have been wrapped
opt.breakindent = true
opt.breakindentopt = { "sbr" }
opt.completeopt:remove("preview")
opt.foldlevelstart = 999

-- Tabs and indenting
opt.autoindent = true -- copy indent from previous line
opt.smartindent = true -- enable nice indent
opt.expandtab = true -- tab with spaces
opt.smarttab = true -- indent using shiftwidth
opt.shiftwidth = 0 -- number of spaces to use for each step of indent
opt.softtabstop = 4 -- tab like 4 spaces
opt.shiftround = true -- round indent to shiftwidth

-- Search options
opt.hlsearch = true -- highlight all matches for the last used search pattern
opt.incsearch = true -- do incremental searching
opt.ignorecase = true -- ignore case when using a search pattern
opt.smartcase = true -- override 'ignorecase' when pattern has upper case characters

-- Buffer options
opt.hidden = true -- don't unload buffer when switching to another one
opt.autoread = true -- auto read changed outside of vim files

-- Edit
opt.backspace = { "indent", "eol", "start" } -- allow backspacing over everything in insert mode

-- Windows
opt.splitbelow = true
opt.splitright = true

opt.history = 50 -- keep 50 lines of command line history
opt.clipboard = { "unnamedplus" }
opt.mouse = "a"
opt.mousemodel = "popup_setpos"

-- Global variables
vim.g.loaded_netrw = 1 -- disable netrw
vim.g.loaded_netrwPlugin = 1
vim.g.editorconfig = false -- disable .editorconfig support

-- Diagnostic Signs
vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "", numhl = "", linehl = "" })
vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "", numhl = "", linehl = "" })
vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "", numhl = "", linehl = "" })
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "", numhl = "", linehl = "" })

-- backups, swapfiles, & undofiles in one place
-- TODO: vim.fn.stdpath
local vimdir = "~/.vim"
local tempdir = vim.fn.expand(vimdir .. "/tmp")
if vim.fn.isdirectory(vim.fn.expand(tempdir)) == 0 then
  vim.fn.mkdir(vim.fn.expand(tempdir), "p")
end
opt.backupdir = tempdir
opt.backup = true
opt.directory = tempdir
opt.swapfile = true
opt.undodir = tempdir
opt.undofile = true
