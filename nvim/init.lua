-- init.lua
-- The main entrypoint for the neovim configuration.

-- Set global variables
require("globals")

-- Load general editor settings
require("settings")

-- Load custom functions
require("functions")

-- Load key mappings
require("mappings")

-- Load autocommands
require("autocmds")

-- Bootstrap and setup lazy.nvim for plugin management
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugin specifications and setup lazy.nvim
require("lazy").setup("plugins")
