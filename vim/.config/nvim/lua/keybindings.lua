vim.g.mapleader = " "

vim.cmd([[
nnoremap <Space> <Nop>
let maplocalleader = " "

" Use Enter for command line
nnoremap <CR> :

" Change current working directory
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Not jump on star, only highlight
nnoremap * *N

" Drop highlight search result
nnoremap <Leader><Space> :nohls<CR>

" Paste/Replace without overwiting default register
xnoremap <Leader>p "_dP

" Prefill replace with current word
nnoremap <Leader>ss :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Tabs
nnoremap gb gT
nnoremap <silent> <Leader>tc :tabnew<CR>
nnoremap <silent> <Leader>tx :tabclose<CR>

" Windows
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Toggle some options
nnoremap <silent> <Leader>op :set paste!<CR>:set paste?<CR>
nnoremap <silent> <Leader>os :set spell!<CR>:set spell?<CR>
nnoremap <silent> <Leader>ow :set wrap!<CR>:set wrap?<CR>
nnoremap <silent> <Leader>ol :set list!<CR>:set list?<CR>
nnoremap <silent> <Leader>on :set number!<CR>:set number?<CR>
nnoremap <silent> <Leader>or :set relativenumber!<CR>:set relativenumber?<CR>
nnoremap <silent> <Leader>ox :set cursorline!<CR>:set cursorcolumn!<CR>
nnoremap <silent> <Leader>ob :let &background = (&background == "dark" ? "light": "dark")<CR>:set background?<CR>
nnoremap <silent> <Leader>oc :let &colorcolumn = (&colorcolumn == 80 ? 0: 80)<CR>:echo "colorcolumn=".&colorcolumn<CR>
nnoremap <silent> <Leader>ot :highlight Normal guibg=None ctermbg=None<CR>

" Write file
map <F2> :w<CR>
map <Leader><F2> :w !sudo tee %<CR>

" Quit
map <F3> :q<CR>
map <Leader><F3> :q!<CR>

" Quickfix and location navigation
map <silent> ]q :cnext<CR>
map <silent> [q :cprev<CR>
map <silent> ]l :lnext<CR>
map <silent> [l :lprev<CR>

" Trigger InsertLeave on Control-C
inoremap <C-C> <Esc>
" see :h c_<Esc> for why this is neccessary
cnoremap <C-C> <C-C>
]])

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)


-- Diagnostic state per buffer
local H = {}
H.buffer_diagnostic_state = {}

local function toggle_diagnostics()
  local buf_id = vim.api.nvim_get_current_buf()
  local buf_state = H.buffer_diagnostic_state[buf_id]
  if buf_state == nil then buf_state = true end

  if buf_state then
    -- vim.diagnostic.show(nil, buf_id, nil, {virtual_text = false})
    vim.diagnostic.disable(buf_id)
    vim.api.nvim_echo({ { 'nodiagnostic' } }, false, {})
  else
    -- vim.diagnostic.show(nil, buf_id, nil, {virtual_text = true})
    vim.diagnostic.enable(buf_id)
    vim.api.nvim_echo({ { '  diagnostic' } }, false, {})
  end

  local new_buf_state = not buf_state
  H.buffer_diagnostic_state[buf_id] = new_buf_state

  return new_buf_state
end

vim.keymap.set('n', '<Leader>ud', toggle_diagnostics)
