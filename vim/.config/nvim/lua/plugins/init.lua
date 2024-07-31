return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      delay = 1000,
      plugins = {
        marks = true,
        registers = true,
        spelling = { enabled = false },
      },
      spec = {
        mode = { "n", "v" },
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>sg", group = "git" },
        { "<leader>t", group = "test" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "windows" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
      },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<A-h>", "<Cmd>TmuxNavigateLeft<CR>", mode = "t", noremap = true, silent = true, desc = "" },
      { "<A-j>", "<Cmd>TmuxNavigateDown<CR>", mode = "t", noremap = true, silent = true, desc = "" },
      { "<A-k>", "<Cmd>TmuxNavigateUp<CR>", mode = "t", noremap = true, silent = true, desc = "" },
      { "<A-l>", "<Cmd>TmuxNavigateRight<CR>", mode = "t", noremap = true, silent = true, desc = "" },
      { "<A-h>", "<Cmd>TmuxNavigateLeft<CR>", mode = "n", noremap = true, silent = true, desc = "" },
      { "<A-j>", "<Cmd>TmuxNavigateDown<CR>", mode = "n", noremap = true, silent = true, desc = "" },
      { "<A-k>", "<Cmd>TmuxNavigateUp<CR>", mode = "n", noremap = true, silent = true, desc = "" },
      { "<A-l>", "<Cmd>TmuxNavigateRight<CR>", mode = "n", noremap = true, silent = true, desc = "" },
    },
    init = function()
      vim.g.tmux_navigator_no_wrap = 1
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },
}
