vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

--vim.opt.colorcolumn = "80"

-- save undo trees in files
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"

-- proper clipboard integration
vim.opt.clipboard:append('unnamedplus')

-- number of undo saved
vim.opt.undolevels = 10000

-- open files in the background using xdg-open
vim.keymap.set('n', 'gX', function()
  local path = vim.fn.expand('%:p:h') .. '/' .. vim.fn.expand('<cfile>')
  vim.fn.system({'xdg-open', path})
end, { silent = true })

-- change 'magicness' to a reasonable value
vim.keymap.set('c', 's/', 's/\\v', { noremap = true })
