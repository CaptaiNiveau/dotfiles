vim.cmd [[packadd packer.nvim]]

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- You add plugins here  
  use 'gaborvecsei/usage-tracker.nvim'

  use 'nvim-lua/plenary.nvim'
  use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }

  use 'nvim-tree/nvim-web-devicons'
  use 'lpoto/telescope-docker.nvim'
  use 'nvim-treesitter/nvim-treesitter'

  use 'MunifTanjim/nui.nvim'

  use 'folke/noice.nvim'
  use { "catppuccin/nvim", as = "catppuccin" }
end)

