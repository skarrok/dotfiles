return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_mode = false,
      contrast = "", -- hard, soft or empty for medium
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
        FloatBorder = { bg = "NONE" },
        TabLineSel = { link = "Pmenu" },
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd({ "User" }, {
        group = vim.api.nvim_create_augroup("custom_gruvbox", { clear = true }),
        pattern = "LazyLoad",
        callback = function(event)
          local gruvbox_loaded = event.event == "User" and event.data == "gruvbox.nvim"

          if gruvbox_loaded then
            vim.cmd([[
              hi link TreesitterContext Pmenu
              hi link NeoTreeFloatBorder Normal
            ]])
          end
        end,
        desc = "Set custom gruvbox highlights",
      })

      require("gruvbox").setup(opts)
      vim.cmd([[colorscheme gruvbox]])
    end,
    keys = {
      {
        "<leader>o/",
        function()
          local gruv = require("gruvbox")
          local contrast = gruv.config.contrast
          if contrast == "soft" then
            contrast = ""
          elseif contrast == "" then
            contrast = "hard"
          elseif contrast == "hard" then
            contrast = "soft"
          end
          gruv.setup({ contrast = contrast })
          vim.cmd([[colorscheme gruvbox]])
          vim.api.nvim_echo({ { "gruvbox contrast=" .. contrast } }, false, {})
        end,
        desc = "Toggle gruvbox contrast",
      },
    },
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
      },
    },
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
