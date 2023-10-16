return {
    "folke/which-key.nvim",
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    "folke/neodev.nvim",
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
        keys = {
            { "<A-h>", "<C-\\><C-n>:TmuxNavigateLeft<CR>",  mode = "t", noremap = true, silent = true, desc = "" },
            { "<A-j>", "<C-\\><C-n>:TmuxNavigateDown<CR>",  mode = "t", noremap = true, silent = true, desc = "" },
            { "<A-k>", "<C-\\><C-n>:TmuxNavigateUp<CR>",    mode = "t", noremap = true, silent = true, desc = "" },
            { "<A-l>", "<C-\\><C-n>:TmuxNavigateRight<CR>", mode = "t", noremap = true, silent = true, desc = "" },
            { "<A-h>", ":<C-U>TmuxNavigateLeft<CR>",        mode = "n", noremap = true, silent = true, desc = "" },
            { "<A-j>", ":<C-U>TmuxNavigateDown<CR>",        mode = "n", noremap = true, silent = true, desc = "" },
            { "<A-k>", ":<C-U>TmuxNavigateUp<CR>",          mode = "n", noremap = true, silent = true, desc = "" },
            { "<A-l>", ":<C-U>TmuxNavigateRight<CR>",       mode = "n", noremap = true, silent = true, desc = "" },
        },
        config = function()
            vim.cmd([[
                let g:tmux_navigator_no_wrap = 1
                let g:tmux_navigator_no_mappings = 1
            ]])
        end,
    },
}
