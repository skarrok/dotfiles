---Return function that checks if command is executable in virtual env
---and returns absolute path to it or nil.
---If no virtual env, returns original command
---@param command string
local function only_venv_command(command)
  ---@type fun(): string?
  return function()
    local captured_command = command
    if captured_command and vim.env.VIRTUAL_ENV then
      captured_command = vim.env.VIRTUAL_ENV .. "/bin/" .. captured_command
      if vim.fn.executable(captured_command) then
        return captured_command
      end
      return nil
    end
    return captured_command
  end
end

---Test if lsp server_name is executable
---@param server_name string
---@return boolean
local function server_executable(server_name)
  local conf = require("lspconfig")[server_name]
  if
    conf
    and conf.document_config
    and conf.document_config.default_config
    and conf.document_config.default_config.cmd
  then
    local cmd = conf.document_config.default_config.cmd
    if type(cmd) == "table" and cmd[1] and vim.fn.executable(cmd[1]) == 1 then
      return true
    end
  end
  return false
end

local function start_ruff()
  local active_clients = {}
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.name == "ruff" then
      table.insert(active_clients, client)
    end
  end

  if #active_clients == 0 and server_executable("ruff") then
    require("lspconfig.configs")["ruff"].launch()
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "python", "toml" })
      end
    end,
  },
  {
    "mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "pyright" })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        python = { "flake8", "mypy" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          -- handlers = {
          --   ["textDocument/publishDiagnostics"] = function() end,
          -- },
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- diagnosticMode = 'workspace',
                -- typeCheckingMode = 'off',
                ignore = { "*" },
              },
            },
          },
        },
        ruff = { mason = false, autostart = false },
      },
      setup = {
        ruff = function()
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "ruff" then
                -- Disable hover in favor of Pyright
                client.server_capabilities.hoverProvider = false
              end
            end,
            desc = "LSP: Disable hover capability from Ruff",
          })

          vim.api.nvim_create_autocmd({ "FileType", "User" }, {
            group = vim.api.nvim_create_augroup("custom_launch_ruff", { clear = true }),
            pattern = { "python", "VenvSelected" },
            callback = start_ruff,
            desc = "LSP: Start ruff if executable found",
          })
        end,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "autoimport", "isort", "black" },
        -- python = function(bufnr)
        --   if require("conform").get_formatter_info("ruff_fix", bufnr).available then
        --     return { "ruff_fix" }
        --   else
        --     return { "autoimport", "isort", "black" }
        --   end
        -- end,
      },
      formatters = {
        autoimport = {
          command = only_venv_command("autoimport"),
          args = { "-" },
          stdin = true,
        },
        isort = { command = only_venv_command("isort") },
        black = { command = only_venv_command("black") },
        ruff_fix = { command = only_venv_command("ruff") },
        ruff_format = { command = only_venv_command("ruff") },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end,  desc = "Debug Class",  ft = "python" },
      },
      config = function()
        local path = require("mason-registry").get_package("debugpy"):get_install_path()
        require("dap-python").setup(path .. "/venv/bin/python")
        table.insert(require("dap").configurations.python, {
          type = "python",
          request = "launch",
          name = "python -m ${module}",
          module = function()
            return vim.fn.input("Module: ")
          end,
        })
      end,
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    cmd = "VenvSelect",
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
          on_venv_activate_callback = function()
            vim.api.nvim_exec_autocmds("User", { pattern = "VenvSelected" })
          end,
        },
      },
    },
    ft = "python",
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
  },
}
