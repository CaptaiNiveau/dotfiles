-- vim.keymap.set("n", "<C-v>", vim.cmd.Ex)
vim.keymap.set("n", "<C-s>", vim.cmd.w)
vim.keymap.set("i", "<C-s>", vim.cmd.w)

vim.keymap.set("v", "J", ">+1<CR>gv=gv")
vim.keymap.set("v", "K", "<-2<CR>gv=gv")

vim.keymap.set("i", "<C-c>", "<Esc>")


local opts = { noremap=true, silent=true }

local function quickfix()
    vim.lsp.buf.code_action({
        filter = function(a) return a.isPreferred end,
        apply = true
    })
end


vim.keymap.set('n', 'C-h', quickfix, opts)
vim.g.mapleader = " "


local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
  "n", 
  "<leader>a", 
  function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr }
)
vim.keymap.set(
  "n", 
  "K",  -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
  function()
    vim.cmd.RustLsp({'hover', 'actions'})
  end,
  { silent = true, buffer = bufnr }
)
