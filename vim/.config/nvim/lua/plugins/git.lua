return {
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "GBrowse" },
    keys = {
      { "<Leader>gs", "<cmd>belowright Git<CR>", silent = true, desc = "Git status" },
      { "<Leader>gd", "<cmd>Gdiff<CR>", silent = true, desc = "Git diff" },
      { "<Leader>gb", "<cmd>Git blame<CR>", silent = true, desc = "Git blame" },
      { "<Leader>gu", "<cmd>Git! pull<CR>", silent = true, desc = "Git pull" },
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
        opts = function()
          vim.api.nvim_create_autocmd("Filetype", {
            pattern = { "fugitive" },
            group = vim.api.nvim_create_augroup("fugitive_whichkeys", { clear = true }),
            callback = function(event)
              local wk = require("which-key")
              wk.add({
                buffer = event.buf,
                { "s", desc = "Stage" },
                { "u", desc = "Unstage" },
                { "U", desc = "Unstage everything" },
                { "X", desc = "Discard" },
                { "-", desc = "Toggle stage" },
                { "=", desc = "Toggle diff" },
                { ">", desc = "Show diff" },
                { "<", desc = "Hide diff" },
                { "gI", desc = "Open .git/info/exclude" },
                { "gi", desc = "Split .git/info/exclude" },
                { "gq", desc = "Close status window" },
                { "g?", desc = "Show fugitive help" },
                { ".", desc = ": <fugitive-object>" },
                { "I", desc = "Patch" },
                { "P", desc = "Patch" },
                { "<CR>", desc = "Open" },
                { "o", desc = "Open split" },
                { "gO", desc = "Open vsplit" },
                { "O", desc = "Open tab" },
                { "p", desc = "Open preview" },
                { "~", desc = "Open file in the first ancestor" },
                { "C", desc = "Open commit" },
                { "(", desc = "Jump prev file, hunk or revision" },
                { ")", desc = "Jump next file, hunk or revision" },
                { "[c", desc = "Jump prev hunk and expand" },
                { "]c", desc = "Jump next hunk and expand" },
                { "[m", desc = "Jump prev file" },
                { "[/", desc = "Jump prev file" },
                { "]m", desc = "Jump next file" },
                { "]/", desc = "Jump next file" },
                { "i", desc = "Next file or hunk and expand" },
                { "[[", desc = "Jump prev section" },
                { "]]", desc = "Jump next section" },
                { "[]", desc = "Jump prev section end" },
                { "][", desc = "Jump next section end" },
                { "*", desc = "Find +/- forward" },
                { "#", desc = "Find +/- backward" },
                { "gu", desc = "Jump to Untracked or Unstaged" },
                { "gU", desc = "Jump to Unstaged" },
                { "gs", desc = "Jump to Staged" },
                { "gp", desc = "Jump to Unpushed" },
                { "gP", desc = "Jump to Unpulled" },
                { "gr", desc = "Jump to Rebasing" },
                {
                  { "d", group = "diff" },
                  { "dp", desc = "Diff (deprecated)" },
                  { "dd", desc = "Diff split" },
                  { "dv", desc = "Diff vsplit" },
                  { "ds", desc = "Diff hsplit" },
                  { "dh", desc = "Diff hsplit" },
                  { "dq", desc = "Close diffs" },
                  { "d?", desc = "diff help" },
                },
                {
                  { "c", group = "commits" },
                  { "cc", desc = "Commit" },
                  { "ca", desc = "Amend and edit" },
                  { "ce", desc = "Amend without edit" },
                  { "cw", desc = "Reword last commit" },
                  { "cvc", desc = "Commit with -v" },
                  { "cva", desc = "Amend with -v" },
                  { "cf", desc = "Fixup" },
                  { "cF", desc = "Fixup and rebase" },
                  { "cs", desc = "Squash" },
                  { "cS", desc = "Squash and rebase" },
                  { "cA", desc = "Squash and edit" },
                  { "c ", desc = ":Git commit ..." },
                  { "crc", desc = "Revert" },
                  { "crn", desc = "Revert (no commit)" },
                  { "cr ", desc = ":Git revert ..." },
                  { "cm ", desc = ":Git merge ..." },
                  { "c?", desc = "Commit help" },
                  { "coup", desc = "Checkout" },
                  { "cb ", desc = ":Git branch ..." },
                  { "co ", desc = ":Git checkout ..." },
                  {
                    { "cz", group = "stash" },
                    { "czz", desc = "Push stash" },
                    { "czw", desc = "Push stash worktree" },
                    { "czs", desc = "Push stash of the stage" },
                    { "czA", desc = "Apply stash" },
                    { "cza", desc = "Apply stash preserve" },
                    { "czP", desc = "Pop stash" },
                    { "czp", desc = "Pop stash preserve" },
                    { "cz ", desc = ":Git stash ..." },
                    { "cz?", desc = "Stash help" },
                  },
                },
                {
                  { "r", group = "rebase" },
                  { "ri", desc = "Rebase on parent" },
                  { "rf", desc = "Rebase autosqash on parent" },
                  { "ru", desc = "Rebase on @{upstream}" },
                  { "rp", desc = "Rebase on @{push}" },
                  { "rr", desc = "Rebase continue" },
                  { "rs", desc = "Rebase skip" },
                  { "ra", desc = "Rebase abort" },
                  { "re", desc = "Rebase edit todo" },
                  { "rw", desc = "Rebase commit with reword" },
                  { "rm", desc = "Rebase commit with edit" },
                  { "rd", desc = "Rebase commit with drop" },
                  { "r ", desc = ":Git rebase ..." },
                  { "r?", desc = "Rebase help" },
                },
              })
            end,
          })
        end,
      },
    },
  },
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
        map({ "n", "v" }, "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk")
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
}
