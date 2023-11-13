return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_mode = false,
      contrast = "",
      overrides = {
        SignColumn = { bg = "NONE" },
        GruvboxRedSign = { bg = "NONE" },
        GruvboxGreenSign = { bg = "NONE" },
        GruvboxYellowSign = { bg = "NONE" },
        GruvboxBlueSign = { bg = "NONE" },
        GruvboxPurpleSign = { bg = "NONE" },
        GruvboxAquaSign = { bg = "NONE" },
        GruvboxOrangeSign = { bg = "NONE" },
      },
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd([[
        " hi link TreesitterContext Pmenu
        colorscheme gruvbox
      ]])
    end,
  },
  {
    "iCyMind/NeoSolarized",
    lazy = false,
  },
  {
    "joshdick/onedark.vim",
    lazy = false,
  },
}
