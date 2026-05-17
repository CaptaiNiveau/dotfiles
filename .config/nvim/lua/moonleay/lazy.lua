local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Auto-install lazy.nvim if not present
if not vim.uv.fs_stat(lazypath) then
    print('Installing lazy.nvim....')
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
    print('Done.')
end

vim.opt.rtp:prepend(lazypath)


require('lazy').setup({
    -- list of plugins here
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    --{'xiyaowong/transparent.nvim'},
    { "catppuccin/nvim", name = "catppuccin", opts = { transparent_background = true, } },
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {
      "necrom4/calcium.nvim",
      cmd = { "Calcium" },
      opts = {
        -- default configuration
        notifications = true,                 -- notify result
        default_mode = "append",              -- or `replace` the expression
        scratchpad = {
            border = "rounded",               -- floating window border style (:help 'winborder')
            virtual_text = {
                format = "= %s",              -- virtual text format
                highlight_group = "Comment",  -- virtual text highlight group
            },
            result_variable = "ans"           -- name of the variable for the last computation result
        },
      },
      keys = {
        -- example keymap
        {
          "<leader>c",
          ":Calcium<CR>",
          desc = "Calculate",
          mode = { "n", "v" },
          silent = true,
        },
      }
    },
    { 
        'mistweaverco/discord.nvim',
        event = "VeryLazy"
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        'mikesmithgh/kitty-scrollback.nvim',
        enabled = true,
        lazy = true,
        cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
        event = { 'User KittyScrollbackLaunch' },
        -- version = '*', -- latest stable version, may have breaking changes if major version changed
        -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
        config = function()
            vim.keymap.set({ 'n' }, '<Esc>', '<Plug>(KsbCloseOrQuitAll)', {})
            require('kitty-scrollback').setup()
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
    }, 
    {
        'tpope/vim-eunuch'
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false, -- This plugin is already lazy
    },
    {
        'nvim-treesitter/nvim-treesitter',
        execute = "TSUpdate"
    }
})
