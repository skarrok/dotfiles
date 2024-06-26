return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_mode = false,
      contrast = "",  -- hard, soft or empty for medium
      overrides = {
        SignColumn = { bg = "NONE" },
        GruvboxRedSign = { bg = "NONE" },
        GruvboxGreenSign = { bg = "NONE" },
        GruvboxYellowSign = { bg = "NONE" },
        GruvboxBlueSign = { bg = "NONE" },
        GruvboxPurpleSign = { bg = "NONE" },
        GruvboxAquaSign = { bg = "NONE" },
        GruvboxOrangeSign = { bg = "NONE" },
        LspInlayHint = { link = "NonText" },
      },
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd([[
        " hi link TreesitterContext Pmenu
        colorscheme gruvbox
      ]])
    end,
    keys = {{
      "<leader>o/",
      function ()
        local gruv = require("gruvbox")
        local contrast = gruv.config.contrast
        if contrast == "soft" then
          contrast = ""
        elseif contrast == "" then
          contrast = "hard"
        elseif contrast == "hard" then
          contrast = "soft"
        end
        gruv.setup({contrast = contrast})
        vim.cmd([[colorscheme gruvbox]])
      end,
      desc = "Toggle gruvbox contrast"
    }}
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      integrations = {
        cmp = true,
        flash = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      }
    }
  },
  {
    "iCyMind/NeoSolarized",
  },
  {
    "joshdick/onedark.vim",
  },
  {
    "folke/tokyonight.nvim",
    opts = {},
  },
}
