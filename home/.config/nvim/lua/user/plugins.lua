-- Setup lazy nvim package manager --
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('user.plugin_setup', {
  headless = {
    process = false,  -- hide git command output
    log = false,      -- hide log messages  
    task = false,     -- hide task start/end
    colors = false,   -- disable ANSI colors
  }
})
