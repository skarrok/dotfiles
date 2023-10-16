local _icons = {
    misc = {
      dots = "󰇘",
    },
    dap = {
      Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint          = " ",
      BreakpointCondition = " ",
      BreakpointRejected  = { " ", "DiagnosticError" },
      LogPoint            = ".>",
    },
    git = {
      added    = " ",
      modified = " ",
      removed  = " ",
    },
    kinds = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Codeium       = "󰘦 ",
      Color         = " ",
      Control       = " ",
      Collapsed     = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Copilot       = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Folder        = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Keyword       = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      Reference     = " ",
      Snippet       = " ",
      String        = " ",
      Struct        = "󰆼 ",
      TabNine       = "󰏚 ",
      Text          = " ",
      TypeParameter = " ",
      Unit          = " ",
      Value         = " ",
      Variable      = "󰀫 ",
    },
  }


-- Plug 'lambdalisue/suda.vim'
-- Plug 'scrooloose/nerdcommenter'
-- Plug 'tpope/vim-commentary'
-- Plug 'milkypostman/vim-togglelist'
--   let g:toggle_list_no_mappings = 1
--   nmap <silent> <leader>wl :call ToggleLocationList()<CR>
--   nmap <silent> <leader>wq :call ToggleQuickfixList()<CR>
-- Plug 'simrat39/rust-tools.nvim'
-- Plug 'mfussenegger/nvim-dap'
-- Plug 'leoluz/nvim-dap-go'
-- Plug 'mfussenegger/nvim-dap-python'
-- Plug 'rcarriga/nvim-dap-ui'
-- Plug 'jose-elias-alvarez/null-ls.nvim'

return {
    import = "plugins.lang"
}
