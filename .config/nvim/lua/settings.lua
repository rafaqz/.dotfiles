-- lua/settings.lua
-- General editor settings

--{{{ Shell and System
vim.opt.shell = "bash"
vim.opt.ttyfast = true
vim.opt.ffs = {"unix", "dos", "mac"}
vim.opt.encoding = "utf8"
vim.cmd("command W w !sudo tee % > /dev/null")

--}}}
--{{{ Bells
vim.opt.errorbells = false
vim.opt.visualbell = false

--}}}
--{{{ UI and Layout
vim.opt.wildmenu = true
vim.opt.wildignore = {"*/.git/*", "*/.hg/*", "*/.svn/*", "*/.DS_Store"}
vim.opt.clipboard = "unnamedplus"
vim.opt.fillchars = {eob = " "}
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.scrolloff = 7
vim.opt.timeoutlen = 500
vim.opt.ruler = true
vim.opt.number = true
vim.opt.cmdheight = 1
vim.opt.hidden = true
vim.opt.laststatus = 2
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.syntax = "enable"
vim.opt.splitbelow = true
vim.opt.splitright = true

--}}}
--{{{ GUI options
if vim.fn.has("gui_running") == 1 then
    vim.opt.guioptions:remove("T", "e")
end
vim.opt.guioptions:remove("r", "R", "l", "L")
vim.opt.guicursor = "n-v-i-c:block"


--}}}
--{{{ Search
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

--}}}
--{{{ Files and Backups
vim.opt.autochdir = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/temp_dirs/undodir"

--}}}
--{{{ Tabs and Indents
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.cmd('filetype plugin indent on')

--}}}
--{{{ Wrapping
vim.opt.linebreak = true
vim.opt.textwidth = 500
vim.opt.wrap = false
vim.opt.whichwrap:append("<,>,h,l,[,]")
vim.opt.synmaxcol = 500

--}}}
--{{{ Performance
vim.opt.redrawtime = 10000

--}}}
--{{{ Highlighting
vim.cmd("highlight Comment cterm=italic")
vim.cmd("highlight Folded term=bold cterm=NONE")

--}}}
