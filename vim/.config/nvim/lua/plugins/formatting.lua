return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format",
      },
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" } })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    opts = {
      format = {
        timeout_ms = 1000,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        sql = { "sql_formatter" },
        -- Use the "*" filetype to run formatters on all filetypes.
        ["*"] = { "codespell" },
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace" },
      },
      formatters = {
        autoimport = {
          command = "autoimport",
          args = { "-" },
          stdin = true,
        },
      },
    },
  },
}
