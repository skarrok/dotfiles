return {
  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
  },

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
    -- init = function()
    --     vim.g.lualine_laststatus = vim.o.laststatus
    --     if vim.fn.argc(-1) > 0 then
    --         -- set an empty statusline till lualine loads
    --         vim.o.statusline = " "
    --     else
    --         -- hide the statusline on the starter page
    --         vim.o.laststatus = 0
    --     end
    -- end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      -- vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = "auto",
          globalstatus = false,
          icons_enabled = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "filename" },
          },
          lualine_c = {
            { "diagnostics" },
          },
          lualine_x = {
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
            },
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
            },
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
        tabline = {
          -- lualine_a = { { 'tabs', mode = 2, separator = nil, max_length = vim.o.columns },
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
  -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  {
    "folke/noice.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline",
      },
      messages = { enabled = true },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = false,
      },
    },
    keys = {
      -- stylua: ignore start
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = { "i", "n", "s", } },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = { "i", "n", "s", } },
      -- stylua: ignore end
    },
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      -- options
    },
  },

  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },
}
