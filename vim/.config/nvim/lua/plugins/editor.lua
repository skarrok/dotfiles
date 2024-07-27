return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    -- branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      {
        "<leader>f",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "float" })
        end,
        desc = "Explorer NeoTree",
      },
      {
        "<leader>gf",
        function()
          require("neo-tree.command").execute({ reveal_force_cwd = true, position = "float" })
        end,
        desc = "Explorer NeoTree (reveal current file)",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    -- init = function()
    --   if vim.fn.argc(-1) == 1 then
    --     local stat = vim.loop.fs_stat(vim.fn.argv(0))
    --     if stat and stat.type == "directory" then
    --       require("neo-tree")
    --     end
    --   end
    -- end,
    opts = {
      sources = { "filesystem" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      popup_border_style = "rounded",
      filesystem = {
        hijack_netrw_behavior = "disabled",
        bind_to_cwd = false,
        follow_current_file = { enabled = false },
        use_libuv_file_watcher = true,
      },
      window = {
        position = "float",
        mappings = {
          ["z"] = "none",
          ["_"] = "close_all_nodes",
          ["-"] = "close_all_subnodes",
          ["+"] = "expand_all_nodes",
          ["o"] = "toggle_node",
          ["O"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "O" } },
          ["Oc"] = { "order_by_created", nowait = false },
          ["Od"] = { "order_by_diagnostics", nowait = false },
          ["Og"] = { "order_by_git_status", nowait = false },
          ["Om"] = { "order_by_modified", nowait = false },
          ["On"] = { "order_by_name", nowait = false },
          ["Os"] = { "order_by_size", nowait = false },
          ["Ot"] = { "order_by_type", nowait = false },
          ["oc"] = "none",
          ["od"] = "none",
          ["og"] = "none",
          ["om"] = "none",
          ["on"] = "none",
          ["os"] = "none",
          ["ot"] = "none",
          ["/"] = "none",
          ["<C-c>"] = "cancel",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
      -- nesting_rules = {
      --   ["go"] = {
      --     pattern = "(.*)%.go$", -- <-- Lua pattern with capture
      --     files = { "%1_test.go" }, -- <-- glob pattern with capture
      --   },
      --   ["docker"] = {
      --     pattern = "^dockerfile$",
      --     ignore_case = true,
      --     files = { ".dockerignore", "docker-compose.*", "dockerfile*" },
      --   },
      -- },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    keys = {
      {
        "<leader>f",
        function()
          require("nvim-tree.api").tree.toggle({ find_file = false, update_root = false, focus = true })
        end,
        desc = "Explorer NvimTree",
      },
      {
        "<leader>gf",
        function()
          require("nvim-tree.api").tree.toggle({ find_file = true, update_root = false, focus = true })
        end,
        desc = "Explorer NvimTree (reveal current file)",
      },
    },
    opts = {
      filters = {
        dotfiles = true,
      },
      git = {
        enable = true,
        ignore = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
      },
      renderer = {
        icons = {
          show = {
            git = true,
          },
        },
      },
    },
  },
  {
    "AndrewRadev/switch.vim",
    keys = {
      { "<Leader>tt", "<Plug>(Switch)", silent = true, desc = "Toggle word" },
    },
    init = function()
      vim.g.switch_mapping = ""
      vim.g.switch_custom_definitions = {
        { "on", "off" },
        { "ON", "OFF" },
        { "On", "Off" },
        { "yes", "no" },
        { "YES", "NO" },
        { "Yes", "No" },
        { "TRUE", "FALSE" },
        { "allow", "deny" },
      }
    end,
  },

  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = false,
        },
        char = {
          enabled = false,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash", },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter", },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash", },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search", },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search", },
    },
  },

  -- Flash Telescope config
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      local function flash(prompt_bufnr)
        require("flash").jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
      })
    end,
  },

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  {
    "RRethy/vim-illuminate",
    lazy = false,
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
      min_count_to_highlight = 2,
      under_cursor = true,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      -- change the highlight style
      vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "CursorLine" })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "CursorLine" })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "CursorLine" })
      --- auto update the highlight style on colorscheme change
      vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        pattern = { "*" },
        callback = function()
          vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "CursorLine" })
          vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "CursorLine" })
          vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "CursorLine" })
        end,
      })
    end,
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope" },
    opts = { signs = false },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment", },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment", },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "coderifous/textobj-word-column.vim",
    enabled = false,
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      disable_mouse = false,
      disabled_keys = {
        ["<Up>"] = {},
        ["<Down>"] = {},
        ["<Left>"] = {},
        ["<Right>"] = {},
      },
      restricted_keys = {
        ["h"] = {},
        ["j"] = {},
        ["k"] = {},
        ["l"] = {},
        ["-"] = {},
        ["+"] = {},
        ["gj"] = {},
        ["gk"] = {},
        ["<CR>"] = {},
        ["<C-M>"] = {},
        ["<C-N>"] = {},
        ["<C-P>"] = {},
        ["<Up>"] = { "n", "i" },
        ["<Down>"] = { "n", "i" },
        ["<Left>"] = { "n", "i" },
        ["<Right>"] = { "n", "i" },
      },
    },
  },
  {
    "nmac427/guess-indent.nvim",
    opts = {},
  },
  {
    "echasnovski/mini.align",
    opts = {},
  },
  {
    "justinmk/vim-gtfo",
    keys = {
      { "gof", desc = "Go to the directory of the current file in the File Manager" },
      { "goF", desc = "Go to the working directory in the File Manager" },
      { "got", desc = "Go to the directory of the current file in the Terminal" },
      { "goT", desc = "Go to the working directory in the Terminal" },
    },
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  {
    "jlanzarotta/bufexplorer",
    config = function()
      vim.g.bufExplorerDefaultHelp = 0
      vim.g.bufExplorerFindActive = 0
      vim.g.bufExplorerShowRelativePath = 1
    end,
  },
  {
    "majutsushi/tagbar",
    keys = {
      { "<F9>", "<cmd>TagbarToggle<CR>", desc = "TagBar" },
    },
    config = function()
      vim.g.tagbar_autofocus = 1
      vim.g.tagbar_autoclose = 1
      vim.g.tagbar_compact = 1
      vim.g.tagbar_foldlevel = 0
      vim.g.tagbar_type_go = {
        ctagstype = "go",
        kinds = {
          "p:package",
          "i:imports:1",
          "c:constants",
          "v:variables",
          "t:types",
          "n:interfaces",
          "w:fields",
          "e:embedded",
          "m:methods",
          "r:constructor",
          "f:functions",
        },
        sro = ".",
        kind2scope = {
          t = "ctype",
          n = "ntype",
        },
        scope2kind = {
          ctype = "t",
          ntype = "n",
        },
        ctagsbin = "gotags",
        ctagsargs = "-sort -silent",
      }
    end,
  },
  {
    "milkypostman/vim-togglelist",
    init = function()
      vim.g.toggle_list_no_mappings = 1
    end,
    keys = {
      { "<leader>wl", "<cmd>call ToggleLocationList()<CR>", desc = "Toggle Location List" },
      { "<leader>wq", "<cmd>call ToggleQuickfixList()<CR>", desc = "Toggle Quickfix List" },
    },
  },
}
