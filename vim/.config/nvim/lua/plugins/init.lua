return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = false },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gs"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    keys = {
      { "<A-h>", "<C-\\><C-n>:TmuxNavigateLeft<CR>", mode = "t", noremap = true, silent = true, desc = "" },
      { "<A-j>", "<C-\\><C-n>:TmuxNavigateDown<CR>", mode = "t", noremap = true, silent = true, desc = "" },
      { "<A-k>", "<C-\\><C-n>:TmuxNavigateUp<CR>", mode = "t", noremap = true, silent = true, desc = "" },
      { "<A-l>", "<C-\\><C-n>:TmuxNavigateRight<CR>", mode = "t", noremap = true, silent = true, desc = "" },
      { "<A-h>", ":<C-U>TmuxNavigateLeft<CR>", mode = "n", noremap = true, silent = true, desc = "" },
      { "<A-j>", ":<C-U>TmuxNavigateDown<CR>", mode = "n", noremap = true, silent = true, desc = "" },
      { "<A-k>", ":<C-U>TmuxNavigateUp<CR>", mode = "n", noremap = true, silent = true, desc = "" },
      { "<A-l>", ":<C-U>TmuxNavigateRight<CR>", mode = "n", noremap = true, silent = true, desc = "" },
    },
    init = function()
      vim.g.tmux_navigator_no_wrap = 1
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },
}
