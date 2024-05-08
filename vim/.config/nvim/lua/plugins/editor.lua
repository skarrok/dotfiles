return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    branch = "v3.x",
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
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git explorer",
      },
      {
        "<F10>",
        function()
          require("neo-tree.command").execute({ source = "document_symbols", toggle = true, position = "right" })
        end,
        desc = "Document Symbols",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = false },
        use_libuv_file_watcher = true,
      },
      window = {
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
    "tpope/vim-fugitive",
    cmd = { "Git", "GBrowse" },
    keys = {
      { "<Leader>gs", ":belowright Git<CR>", silent = true, desc = "Git status" },
      { "<Leader>gd", ":Gdiff<CR>", silent = true, desc = "Git diff" },
      { "<Leader>gb", ":Git blame<CR>", silent = true, desc = "Git blame" },
      { "<Leader>gu", ":Git! pull<CR>", silent = true, desc = "Git pull" },
      { "<leader>gp", ":Git push", silent = false, desc = "Git push ..." },
    },
    dependencies = {
      {
        "shumphrey/fugitive-gitlab.vim",
        config = function()
          vim.g.fugitive_gitlab_domains = {}
          vim.api.nvim_create_user_command("Browse", function(opts)
            vim.fn.system({ "xdg-open", opts.fargs[1] })
          end, { nargs = 1 })
        end,
      },
      {
        "folke/which-key.nvim",
        optional = true,
        config = function()
          vim.api.nvim_create_autocmd("Filetype", {
            pattern = { "fugitive" },
            group = vim.api.nvim_create_augroup("fugitive_whichkeys", { clear = true }),
            callback = function(event)
              local wk = require("which-key")
              wk.register({
                ["s"] = { "Stage" },
                ["u"] = { "Unstage" },
                ["U"] = { "Unstage everything" },
                ["X"] = { "Discard" },
                ["-"] = { "Toggle stage" },
                ["="] = { "Toggle diff" },
                [">"] = { "Show diff" },
                ["<"] = { "Hide diff" },
                ["gI"] = { "Open .git/info/exclude" },
                ["gi"] = { "Split .git/info/exclude" },
                ["gq"] = { "Close status window" },
                ["g?"] = { "Show fugitive help" },
                ["."] = { ": <fugitive-object>" },
                ["I"] = { "Patch" },
                ["P"] = { "Patch" },
                ["<CR>"] = { "Open" },
                ["o"] = { "Open split" },
                ["gO"] = { "Open vsplit" },
                ["O"] = { "Open tab" },
                ["p"] = { "Open preview" },
                ["~"] = { "Open file in the first ancestor" },
                ["C"] = { "Open commit" },
                ["("] = { "Jump prev file, hunk or revision" },
                [")"] = { "Jump next file, hunk or revision" },
                ["[c"] = { "Jump prev hunk and expand" },
                ["]c"] = { "Jump next hunk and expand" },
                ["[m"] = { "Jump prev file" },
                ["[/"] = { "Jump prev file" },
                ["]m"] = { "Jump next file" },
                ["]/"] = { "Jump next file" },
                ["i"] = { "Next file or hunk and expand" },
                ["[["] = { "Jump prev section" },
                ["]]"] = { "Jump next section" },
                ["[]"] = { "Jump prev section end" },
                ["]["] = { "Jump next section end" },
                ["*"] = {  "Find +/- forward" },
                ["#"] = {  "Find +/- backward" },
                ["gu"] = {  "Jump to Untracked or Unstaged" },
                ["gU"] = {  "Jump to Unstaged" },
                ["gs"] = {  "Jump to Staged" },
                ["gp"] = {  "Jump to Unpushed" },
                ["gP"] = {  "Jump to Unpulled" },
                ["gr"] = {  "Jump to Rebasing" },
                ["d"] = {
                  name = "+diff",
                  ["p"] = { "Diff (deprecated)" },
                  ["d"] = { "Diff split" },
                  ["v"] = { "Diff vsplit" },
                  ["s"] = { "Diff hsplit" },
                  ["h"] = { "Diff hsplit" },
                  ["q"] = { "Close diffs" },
                  ["?"] = { "diff help" },
                },
                ["c"] = {
                  name = "+commits",
                  ["c"] = { "Commit" },
                  ["a"] = { "Amend and edit" },
                  ["e"] = { "Amend without edit" },
                  ["w"] = { "Reword last commit" },
                  ["vc"] = { "Commit with -v" },
                  ["va"] = { "Amend with -v" },
                  ["f"] = { "Fixup" },
                  ["F"] = { "Fixup and rebase" },
                  ["s"] = { "Squash" },
                  ["S"] = { "Squash and rebase" },
                  ["A"] = { "Squash and edit" },
                  [" "] = { ":Git commit ..." },
                  ["rc"] = { "Revert" },
                  ["rn"] = { "Revert (no commit)" },
                  ["r "] = { ":Git revert ..." },
                  ["m "] = { ":Git merge ..." },
                  ["?"] = { "Commit help" },
                  ["oo"] = { "Checkout" },
                  ["b "] = { ":Git branch ..." },
                  ["o "] = { ":Git checkout ..." },
                  ["z"] = {
                    name = "+stash",
                    ["z"] = "Push stash",
                    ["w"] = "Push stash worktree",
                    ["s"] = "Push stash of the stage",
                    ["A"] = "Apply stash",
                    ["a"] = "Apply stash preserve",
                    ["P"] = "Pop stash",
                    ["p"] = "Pop stash preserve",
                    [" "] = ":Git stash ...",
                    ["?"] = "Stash help",
                  },
                },
                ["r"] = {
                  name = "+rebase",
                  ["i"] = { "Rebase on parent" },
                  ["f"] = { "Rebase autosqash on parent" },
                  ["u"] = { "Rebase on @{upstream}" },
                  ["p"] = { "Rebase on @{push}" },
                  ["r"] = { "Rebase continue" },
                  ["s"] = { "Rebase skip" },
                  ["a"] = { "Rebase abort" },
                  ["e"] = { "Rebase edit todo" },
                  ["w"] = { "Rebase commit with reword" },
                  ["m"] = { "Rebase commit with edit" },
                  ["d"] = { "Rebase commit with drop" },
                  [" "] = { ":Git rebase ..." },
                  ["?"] = { "Rebase help" },
                },
              }, { buffer = event.buf })
            end,
          })
        end,
      },
    },
  },
  {
    "AndrewRadev/switch.vim",
    keys = {
      { "<Leader>tt", "<Plug>(Switch)", silent = true, desc = "Toggle word" },
    },
    config = function()
      vim.cmd([[
                let g:switch_mapping = ""
                let g:switch_custom_definitions =
                        \ [
                        \   [ 'on', 'off' ],
                        \   [ 'ON', 'OFF' ],
                        \   [ 'On', 'Off' ],
                        \   [ 'yes', 'no' ],
                        \   [ 'YES', 'NO' ],
                        \   [ 'Yes', 'No' ],
                        \   [ 'TRUE', 'FALSE' ],
                        \   [ 'allow', 'deny' ],
                        \ ]
            ]])
    end,
  },
  -- Fuzzy finder.
  -- The default key bindings to find files will use Telescope's
  -- `find_files` or `git_files` depending on whether the
  -- directory is a git repo.
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      -- project management
      {
        "ahmedkhalf/project.nvim",
        opts = {
          manual_mode = true,
        },
        event = "VeryLazy",
        config = function(_, opts)
          require("project_nvim").setup(opts)
          require("telescope").load_extension("projects")
        end,
        keys = {
          { "<leader>sp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
        },
      },
    },
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>sf", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files (hidden)" },
      { "<leader>sa", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Find Word" },
      { "z=", "<cmd>Telescope spell_suggest theme=cursor<cr>", desc = "Spell suggest" },
      { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume" },
      { "<leader>s,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
      { "<leader>s:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      -- git
      { "<leader>sgb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      { "<leader>sgf", "<cmd>Telescope git_files<cr>", desc = "Git files" },
      { "<leader>sgc", "<cmd>Telescope git_commits<CR>", desc = "Git commits" },
      { "<leader>sgs", "<cmd>Telescope git_status<CR>", desc = "Git status" },
      -- search
      { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>sA", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sO", "<cmd>Telescope colorscheme enable_preview=true<CR>", desc = "ColorScheme with preview" },
      -- {
      --     "<leader>ss",
      --     function()
      --         require("telescope.builtin").lsp_document_symbols({
      --             symbols = require("lazyvim.config").get_kind_filter(),
      --         })
      --     end,
      --     desc = "Goto Symbol",
      -- },
      -- {
      --     "<leader>sS",
      --     function()
      --         require("telescope.builtin").lsp_dynamic_workspace_symbols({
      --             symbols = require("lazyvim.config").get_kind_filter(),
      --         })
      --     end,
      --     desc = "Goto Symbol (Workspace)",
      -- },
    },
    opts = function()
      local actions = require("telescope.actions")

      local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end
      local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
      end

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_selected_with_trouble,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_cursor({}),
          },
        },
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

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      attach_to_untracked = false,
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        -- stylua: ignore end
      end,
    },
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

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true, group = true, padding = false, indent_lines = true, auto_preview = false },
    keys = {
      { "<Leader>wt", "<cmd>TroubleToggle<CR>", desc = "Trouble" },
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>wl", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>wq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment", },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment", },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "michaeljsmith/vim-indent-object",
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
    "junegunn/vim-easy-align",
    config = function()
      vim.cmd([[
        xmap ga <Plug>(EasyAlign)
        nmap ga <Plug>(EasyAlign)
      ]])
    end,
  },
  {
    "machakann/vim-sandwich",
    enabled = false,
    config = function()
      vim.cmd([[
        let g:sandwich_no_default_key_mappings = 1
        let g:operator_sandwich_no_default_key_mappings = 1
        silent! nmap <unique> csa <Plug>(operator-sandwich-add)
        silent! xmap <unique> csa <Plug>(operator-sandwich-add)
        silent! omap <unique> csa <Plug>(operator-sandwich-g@)
        silent! xmap <unique> csd <Plug>(operator-sandwich-delete)
        silent! xmap <unique> csr <Plug>(operator-sandwich-replace)
        silent! nmap <unique><silent> csd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
        silent! nmap <unique><silent> csr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
        silent! nmap <unique><silent> csdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
        silent! nmap <unique><silent> csrb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
      ]])
    end,
  },
  {
    "justinmk/vim-gtfo",
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
      { "<F9>", "<cmd>:TagbarToggle<CR>", desc = "TagBar" },
    },
    config = function()
      vim.cmd([[
        let g:tagbar_autofocus = 1
        let g:tagbar_autoclose = 1
        let g:tagbar_compact = 1
        let g:tagbar_foldlevel = 0
        let g:tagbar_type_go = {
                \ 'ctagstype' : 'go',
                \ 'kinds'     : [
                        \ 'p:package',
                        \ 'i:imports:1',
                        \ 'c:constants',
                        \ 'v:variables',
                        \ 't:types',
                        \ 'n:interfaces',
                        \ 'w:fields',
                        \ 'e:embedded',
                        \ 'm:methods',
                        \ 'r:constructor',
                        \ 'f:functions'
                \ ],
                \ 'sro' : '.',
                \ 'kind2scope' : {
                        \ 't' : 'ctype',
                        \ 'n' : 'ntype'
                \ },
                \ 'scope2kind' : {
                        \ 'ctype' : 't',
                        \ 'ntype' : 'n'
                \ },
                \ 'ctagsbin'  : 'gotags',
                \ 'ctagsargs' : '-sort -silent'
        \ }
    ]])
    end,
  },
}
