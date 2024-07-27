---@param sources cmp.SourceConfig
local function insert_codeium(sources)
  table.insert(sources, 1, {
    name = "codeium",
    group_index = 1,
    priority = 100,
  })
end

return {
  -- codeium cmp source
  {
    "nvim-cmp",
    dependencies = {
      -- codeium
      {
        "Exafunction/codeium.nvim",
        cmd = "Codeium",
        build = ":Codeium Auth",
        opts = {},
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      insert_codeium(opts.sources)
    end,
    keys = {
      {
        "<Leader>oa",
        function()
          local cmp = require("cmp")
          local utils = require("utils")
          local sources = cmp.get_config().sources
          local found = false
          for i = #sources, 1, -1 do
            if sources and sources[i].name == "codeium" then
              table.remove(sources, i)
              found = true
            end
          end
          if not found and sources then
            insert_codeium(sources)
          end
          cmp.setup.buffer({ sources = sources })
          utils.echo_feature("codeium", not found)
        end,
        desc = "Toggle codeium",
      },
    },
  },
}
