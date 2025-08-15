-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set theme
vim.o.termguicolors = true
vim.cmd('colorscheme nord-macos')

-- Show cursorline
vim.o.cursorline = true

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-- Set spacing defaults
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = false

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Configure Explorer
vim.g.netrw_banner = 1      -- toggle explorer banner
vim.g.netrw_liststyle = 3   -- default to tree view, `i` to shuffle around
