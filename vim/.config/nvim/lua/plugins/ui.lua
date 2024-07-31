return {
  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    opts = {
      select = {
        telescope = require("telescope.themes").get_cursor({ previewer = false }),
      },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      return {
        options = {
          theme = "auto",
          globalstatus = false,
          icons_enabled = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        },
        sections = {
          lualine_a = {
            { "mode" },
          },
          lualine_b = {
            { "filename", path = 1 },
          },
          lualine_c = {
            { "diagnostics" },
          },
          lualine_x = {
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
            },
            {
              "diff",
            },
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = {
            "branch",
          },
          lualine_z = {
            { "progress" },
            { "location" },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 3 } },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "neo-tree", "lazy", "fugitive", "mason", "nvim-dap-ui", "trouble", "quickfix" },
      }
    end,
  },

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    keys = {
      { "<Leader>I", ":IBLToggle<CR>", desc = "Toggle Indent Lines" },
    },
    opts = {
      enabled = false,
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },

  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },
}
