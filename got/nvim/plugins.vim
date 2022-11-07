call plug#begin('~/.config/nvim/plugs')
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lervag/vimtex'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'jamestthompson3/nvim-remote-containers'
Plug 'shime/vim-livedown'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'vim-scripts/SQLComplete.vim'
Plug 'mechatroner/rainbow_csv'
Plug 'vim-scripts/SQLUtilities'
call plug#end()
lua<<EOF
   -- Setup nvim-tree.
require("nvim-tree").setup()
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
EOF
