vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map({ "n" }, "<Space>", "<Nop>")

-- Use Enter for command line
map({ "n", "v" }, "<CR>", ":", { desc = "Use Enter for command line" })

-- Change current working directory
map({ "n" }, "<Leader>cd", "<cmd>cd %:p:h<CR><cmd>pwd<CR>", { desc = "Change current working directory" })

-- Not jump on star, only highlight
map({ "n" }, "*", "*N", { desc = "Not jump on star, only highlight" })

-- Drop highlight search result
map({ "n" }, "<Leader><Space>", "<cmd>nohls<CR><cmd>echo<CR>", { desc = "Drop highlight search result" })

-- Paste/Replace without overwriting default register
map({ "x" }, "<Leader>p", '"_dP', { desc = "Paste/Replace without overwriting default register" })

-- Prefill replace with current word
map(
  { "n" },
  "<Leader>ss",
  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Prefill replace with current word" }
)

-- Tabs
map({ "n" }, "gb", "gT", { desc = "Go to previous tab" })
map({ "n" }, "<Leader>tc", "<cmd>tabnew<CR>", { desc = "Create new tab" })
map({ "n" }, "<Leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })

-- Windows
map({ "t" }, "<A-h>", [[<C-\><C-N><C-w>h]], { desc = "Window left" })
map({ "t" }, "<A-j>", [[<C-\><C-N><C-w>j]], { desc = "Window down" })
map({ "t" }, "<A-k>", [[<C-\><C-N><C-w>k]], { desc = "Window up" })
map({ "t" }, "<A-l>", [[<C-\><C-N><C-w>l]], { desc = "Window right" })
map({ "i" }, "<A-h>", [[<C-\><C-N><C-w>h]], { desc = "Window left" })
map({ "i" }, "<A-j>", [[<C-\><C-N><C-w>j]], { desc = "Window down" })
map({ "i" }, "<A-k>", [[<C-\><C-N><C-w>k]], { desc = "Window up" })
map({ "i" }, "<A-l>", [[<C-\><C-N><C-w>l]], { desc = "Window right" })
map({ "n" }, "<A-h>", [[<C-w>h]], { desc = "Window left" })
map({ "n" }, "<A-j>", [[<C-w>j]], { desc = "Window down" })
map({ "n" }, "<A-k>", [[<C-w>k]], { desc = "Window up" })
map({ "n" }, "<A-l>", [[<C-w>l]], { desc = "Window right" })

-- Toggle some options
map({ "n" }, "<Leader>os", "<cmd>set spell!<CR><cmd>set spell?<CR>", { desc = "Toggle spellcheck" })
map({ "n" }, "<Leader>ow", "<cmd>set wrap!<CR><cmd>set wrap?<CR>", { desc = "Toggle line wrapping" })
map({ "n" }, "<Leader>ol", "<cmd>set list!<CR><cmd>set list?<CR>", { desc = "Toggle showing non-printable characters" })
map({ "n" }, "<Leader>on", "<cmd>set number!<CR><cmd>set number?<CR>", { desc = "Toggle line numbers" })
map(
  { "n" },
  "<Leader>or",
  "<cmd>set relativenumber!<CR><cmd>set relativenumber?<CR>",
  { desc = "Toggle relative line numbers" }
)
map({ "n" }, "<Leader>ox", "<cmd>set cursorline!<CR><cmd>set cursorcolumn!<CR>", { desc = "Toggle crosshair" })
map(
  { "n" },
  "<Leader>ob",
  '<cmd>let &background = (&background == "dark" ? "light": "dark")<CR><cmd>set background?<CR>',
  { desc = "Toggle background" }
)
map(
  { "n" },
  "<Leader>oc",
  '<cmd>let &colorcolumn = (&colorcolumn == 80 ? 0: 80)<CR><cmd>echo "colorcolumn=".&colorcolumn<CR>',
  { desc = "Toggle column line at 80" }
)
map(
  { "n" },
  "<Leader>ot",
  "<cmd>highlight Normal guibg=None ctermbg=None<CR>",
  { desc = "Make background transparent" }
)

-- Write file
map("", "<F2>", "<cmd>up<CR>", { desc = "Write file" })
map("", "<Leader><F2>", "<cmd>w !sudo tee %<CR>", { desc = "Write file as root" })

-- Quit
map("", "<F3>", "<cmd>quit<CR>", { desc = "Quit" })
map("", "<Leader><F3>", "<cmd>quit!<CR>", { desc = "Quit without saving" })

-- Quickfix and location navigation
map("", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix" })
map("", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix" })
map("", "]l", "<cmd>lnext<CR>", { desc = "Next loclist" })
map("", "[l", "<cmd>lprev<CR>", { desc = "Previous loclist" })

-- Trigger InsertLeave on Control-C
map({ "i" }, "<C-C>", "<Esc>")
-- see :h c_<Esc> for why this is necessary
map({ "c" }, "<C-C>", "<C-C>")

map("n", "<Leader>e", vim.diagnostic.open_float, { silent = true, desc = "Open diagnostic float" })
map("n", "[d", vim.diagnostic.goto_prev, { silent = true, desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { silent = true, desc = "Go to next diagnostic" })
map("n", "<Leader>qq", vim.diagnostic.setloclist, { silent = true, desc = "Open diagnostics list" })

local utils = require("utils")
map("n", "<Leader>ud", utils.toggle_diagnostics, { desc = "Toggle diagnostics" })
map("n", "<Leader>uh", utils.toggle_inlay_hints, { desc = "Toggle inlay hints" })
