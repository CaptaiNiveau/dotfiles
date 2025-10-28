require("nvim-treesitter.install").prefer_git = true

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.kitty = {
  install_info = {
    url = "https://github.com/OXY2DEV/tree-sitter-kitty", 
    files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
    branch = "main", -- default branch in case of git repo if different from master
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  },
  filetype = "kitty", -- if filetype does not match the parser name
}

require('nvim-treesitter.configs').setup({
  ensure_installed = { 'kitty' },
  highlight = {
    enable = true,
  },
  auto_install = true,
})

-- Get current tree sitter language
-- Use with :lua print(current_treesitter_lang())
function _G.current_treesitter_lang()
  local parser = require'vim.treesitter.highlighter'.active[vim.api.nvim_get_current_buf()]
  if parser then
    return parser.tree:lang()
  end
end
