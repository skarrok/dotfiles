local M = {}

M.icons = {
  misc = {
    dots = "󰇘",
  },
  dap = {
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
  },
  kinds = {
    Array = " ",
    Boolean = "󰨙 ",
    Class = " ",
    Codeium = "󰘦 ",
    Color = " ",
    Control = " ",
    Collapsed = " ",
    Constant = "󰏿 ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = "󰊕 ",
    Module = " ",
    Namespace = "󰦮 ",
    Null = " ",
    Number = "󰎠 ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = "󰆼 ",
    TabNine = "󰏚 ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = "󰀫 ",
  },
}

function M.echo_feature(name, status)
  local message = ""
  if status == true then
    message = "  " .. name
  else
    message = "no" .. name
  end
  vim.api.nvim_echo({ { message } }, false, {})
end

function M.toggle_inlay_hints()
  local enabled = not vim.lsp.inlay_hint.is_enabled({})
  vim.lsp.inlay_hint.enable(enabled)
  M.echo_feature("inlayhints", enabled)
end

-- Diagnostic state per buffer
local H = {}
H.buffer_diagnostic_state = {}

function M.toggle_diagnostics()
  local buf_id = vim.api.nvim_get_current_buf()
  local buf_state = H.buffer_diagnostic_state[buf_id]
  if buf_state == nil then
    buf_state = true
  end

  if buf_state then
    -- vim.diagnostic.show(nil, buf_id, nil, {virtual_text = false})
    -- vim.diagnostic.config({ virtual_text = false })
    vim.diagnostic.enable(false, { bufnr = buf_id })
  else
    -- vim.diagnostic.show(nil, buf_id, nil, {virtual_text = true})
    vim.diagnostic.enable(true, { bufnr = buf_id })
  end

  local new_buf_state = not buf_state
  H.buffer_diagnostic_state[buf_id] = new_buf_state
  M.echo_feature("diagnostic", new_buf_state)

  return new_buf_state
end

-- thanks to lazyvim
---@param opts {skip_next: string, skip_ts: string[], skip_unbalanced: boolean, markdown: boolean}
function M.pairs(opts)
  -- LazyVim.toggle.map("<leader>up", {
  --   name = "Mini Pairs",
  --   get = function()
  --     return not vim.g.minipairs_disable
  --   end,
  --   set = function(state)
  --     vim.g.minipairs_disable = not state
  --   end,
  -- })
  local pairs = require("mini.pairs")
  pairs.setup(opts)
  local open = pairs.open
  pairs.open = function(pair, neigh_pattern)
    if vim.fn.getcmdline() ~= "" then
      return open(pair, neigh_pattern)
    end
    local o, c = pair:sub(1, 1), pair:sub(2, 2)
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local next = line:sub(cursor[2] + 1, cursor[2] + 1)
    local before = line:sub(1, cursor[2])
    if opts.markdown and o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
      return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
    end
    if opts.skip_next and next ~= "" and next:match(opts.skip_next) then
      return o
    end
    if opts.skip_ts and #opts.skip_ts > 0 then
      local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
      for _, capture in ipairs(ok and captures or {}) do
        if vim.tbl_contains(opts.skip_ts, capture.capture) then
          return o
        end
      end
    end
    if opts.skip_unbalanced and next == c and c ~= o then
      local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
      local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
      if count_close > count_open then
        return o
      end
    end
    return open(pair, neigh_pattern)
  end
end

-- Tabline, defines how tabpages title looks like
function TabLine()
  local tabline = ""
  for index = 1, vim.fn.tabpagenr("$") do
    -- select the highlighting
    if index == vim.fn.tabpagenr() then
      tabline = tabline .. "%#TabLineSel#"
    else
      tabline = tabline .. "%#TabLine#"
    end

    -- set the tab page number (for mouse clicks)
    tabline = tabline .. "%" .. index .. "T"

    local buflist = vim.fn.tabpagebuflist(index)
    local win_num = vim.fn.tabpagewinnr(index)
    local bufname = vim.fn.bufname(buflist[win_num])
    local filetype = vim.bo[buflist[win_num]].filetype
    local buftype = vim.bo[buflist[win_num]].buftype

    if filetype == "fugitive" then
      bufname = "fugitive: " .. vim.fn.fnamemodify(bufname, ":h:h:t")
    elseif buftype == "help" then
      bufname = "help:" .. vim.fn.fnamemodify(bufname, ":t:r")
    elseif buftype == "terminal" then
      local match = string.match(vim.split(bufname, " ")[1], "term:.*:(%a+)")
      bufname = match ~= nil and match or vim.fn.fnamemodify(vim.env.SHELL, ":t")
    elseif bufname == "" then
      bufname = "[No Name]"
    else
      -- bufname = vim.fn.fnamemodify(bufname, ":~:.")
      -- bufname = vim.fn.fnamemodify(bufname, ":p")
      -- bufname = vim.fn.fnamemodify(bufname, ":p:~")
      bufname = vim.fn.fnamemodify(bufname, ":t")
    end

    if vim.api.nvim_get_option_value("modified", { buf = buflist[win_num] }) then
      bufname = bufname .. " [+]"
    end

    tabline = tabline .. " " .. index .. " " .. bufname .. " "
  end

  -- after the last tab fill with TabLineFill and reset tab page nr
  tabline = tabline .. "%#TabLineFill#%T"

  -- right-align the label to close the current tab page
  if vim.fn.tabpagenr("$") > 1 then
    tabline = tabline .. "%=%#TabLine#%999XX"
  end

  return tabline
end
vim.go.tabline = "%!v:lua.TabLine()"

return M
