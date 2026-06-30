-- lua/plugins.lua
-- Plugin specifications for lazy.nvim

return {

-- {{{ Bling 
-- 'nvim-lualine/lualine.nvim',
'nvim-tree/nvim-web-devicons',
'nvim-mini/mini.icons',
{
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
},
{ 
  'lukas-reineke/indent-blankline.nvim', 
  main = "ibl", 
  ---@module "ibl"
  ---@type ibl.config
  opts = {}, 
  config = function()
    require("ibl").setup({
      scope = { enabled = false },
      indent = { char="▏" },
    })
  end,
},
{
  'folke/noice.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  config = function()
    require("noice").setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    })
  end,
},
{
  'rcarriga/nvim-notify',
  config = function()
    vim.keymap.set("n", "<Esc>", function() require("notify").dismiss() end, { desc = "Dismiss notify popup" })
  end,
},
{
  "folke/twilight.nvim",
  opts = {
    dimming = {
      alpha = 0.45, -- amount of dimming
    },
    context = 12, -- amount of lines we will try to show around the current line
    treesitter = true, -- use treesitter when available for the filetype
    -- treesitter is used to automatically expand the visible text,
    -- but you can further control the types of nodes that should always be fully expanded
    expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
      "function",
      "method",
      "table",
      "if_statement",
    },
    exclude = {}, -- exclude these filetypes
  }
},
{
  'junegunn/goyo.vim',
  init = function()
    vim.g.goyo_width = 100
  end,
  config = function()
    vim.cmd([[
      function! s:goyo_enter()
        if exists('g:crystalline_loaded') | call crystalline#ClearStatusline() | 
        endif
        set signcolumn=no
        set statusline=
        let b:quitting = 0
        let b:quitting_bang = 0
        autocmd QuitPre <buffer> let b:quitting = 1
        cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
        call feedkeys(":\e")
      endfunction
        function! s:goyo_leave()
        if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
          if b:quitting_bang | qa! | else | qa | 
          endif
        endif
        if exists('g:crystalline_loaded') | call crystalline#InitStatusline() | 
        endif
        set signcolumn=yes
        set statusline=%!g:CrystallineStatuslineFn(winnr())
        set laststatus=2
        if exists('g:crystalline_loaded') | call crystalline#UpdateStatusline(win_getid()) | 
        endif
      endfunction
      autocmd User GoyoEnter call <SID>goyo_enter()
      autocmd User GoyoLeave call <SID>goyo_leave()
    ]])
  end,
},

-----------------------------------------------------------------------------------------}}}
-- {{{ Themes 
{
  'm00qek/baleia.nvim',
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "iron",
      callback = function() vim.b.baleia_ansii_colors = 1 end,
      desc = "Enable baleia ANSI colors for iron buffers",
    })
  end,
},
'rakr/vim-one',
'craftzdog/solarized-osaka.nvim',
{
  'rebelot/kanagawa.nvim',
  priority = 1000, -- Ensure it loads first
},

'shaunsingh/nord.nvim',
-- 'scottmckendry/cyberdream.nvim',
{ 
  'sainnhe/everforest',
  config = function()
    vim.g.everforest_background = 'hard'
  end,
},
{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
-- 'AlexvZyl/nordic.nvim',
-- 'savq/melange-nvim',
'yorickpeterse/vim-paper',
'Mofiqul/dracula.nvim',
{ 
  'folke/tokyonight.nvim',
  config = function()
    vim.cmd("colorscheme tokyonight-storm")
  end,
},
-- 'ficd0/ashen.nvim',
-- 'ramojus/mellifluous.nvim',
'rose-pine/neovim',
'maxmx03/fluoromachine.nvim',
-- 'everviolet/nvim',
'thesimonho/kanagawa-paper.nvim',
-- 'cocopon/iceberg.vim',
{ 
  'ellisonleao/gruvbox.nvim',
  config = function()
    -- vim.cmd("colorscheme gruvbox")
  end,
},

-----------------------------------------------------------------------------------------}}}
-- {{{ Editing
'intuited/visdo',
'tpope/vim-surround',
'tpope/vim-repeat',
-- 'tpope/vim-commentary',
'numToStr/Comment.nvim',
'tpope/vim-unimpaired',
'dahu/vim-fanfingtastic',
-- 'michaeljsmith/vim-indent-object',
'tommcdo/vim-lion',
{
  'vim-scripts/YankRing.vim',
  init = function()
    vim.g.yankring_history_dir = '~/.vim/'
  end,
},
'mbbill/undotree',
{ 
  "samjwill/nvim-unception",
  init = function()
    -- Optional settings go here!
    vim.g.unception_open_buffer_in_new_tab = true
  end
},
'brooth/far.vim',

-----------------------------------------------------------------------------------------}}}
-- {{{ Completion
'folke/which-key.nvim',
'hrsh7th/cmp-nvim-lsp',
'hrsh7th/cmp-buffer',
'hrsh7th/cmp-path',
'hrsh7th/cmp-cmdline',
-- 'amarakon/nvim-cmp-lua-latex-symbols',
'petertriho/cmp-git',
'hrsh7th/vim-vsnip',
'kdheepak/cmp-latex-symbols',
{
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'amarakon/nvim-cmp-lua-latex-symbols',
    'petertriho/cmp-git',
    'hrsh7th/vim-vsnip',
    'kdheepak/cmp-latex-symbols',
  },
  config = function()
    local cmp = require('cmp')
    cmp.setup({
      snippet = {
        expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then cmp.select_next_item() else fallback() end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then cmp.select_prev_item() else fallback() end
        end, {"i", "s"}),
      }),
      sources = cmp.config.sources({
        { name = 'buffer', get_bufnrs = function() return vim.api.nvim_list_bufs() end },
        { name = 'cmdline_history' },
        { name = 'vsnip' },
        { name = 'git' },
        { name = "latex_symbols" },
        { name = 'nvim_lsp' },
      })
    })
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({ { name = 'git' } }, { { name = 'buffer' } })
    })
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = 'buffer' }, { name = "latex_symbols" } },
    })
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
    })
  end,
},

-----------------------------------------------------------------------------------------}}}
-- {{{ Git
'lewis6991/gitsigns.nvim',
'tpope/vim-fugitive',
{
  'int3/vim-extradite',
  init = function()
    vim.g.extradite_width = 60
  end,
},
{ 'sindrets/diffview.nvim',
  config = function()
    vim.keymap.set('n', '<leader>gdd', ':DiffviewOpen<cr>')
    vim.keymap.set('n', '<leader>gdu', ':DiffviewOpen -uno<cr>')
    vim.keymap.set('n', '<leader>gdm', ':DiffviewOpen main<cr>')
    vim.keymap.set('n', '<leader>gdh', ':DiffviewOpen HEAD')
    vim.keymap.set('n', '<leader>gdx', ':DiffviewOpen ')
    vim.keymap.set('n', '<leader>gdl', ':DiffviewFileHistory<cr>')
    vim.keymap.set('n', '<leader>gdc', ':DiffviewClose<cr>')
  end,
},

-----------------------------------------------------------------------------------------}}}
-- {{{ Navigation
{
  'rafaqz/ranger.vim',
  init = function()
    vim.g.ranger_terminal = "alacritty -h"
    vim.g.ranger_insert_format = '.'
  end,
},
{
  'nvim-telescope/telescope.nvim',
  dependencies = { 
    'nvim-lua/plenary.nvim', 
    'nvim-telescope/telescope-fzf-native.nvim',
    'jvgrootveld/telescope-zoxide',
    'nvim-telescope/telescope-frecency.nvim',
  },
  config = function()
    local telescope = require('telescope')
    telescope.setup({
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        zoxide = {},
      },
    })
    telescope.load_extension('fzf')
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', ',f', function() require('telescope.builtin').git_files({ hidden = true }) end, { desc = 'Find files (including hidden)' })
    vim.keymap.set('n', ',g', builtin.live_grep, { desc = 'Live grep' })
    vim.keymap.set('n', ',b', builtin.buffers, { desc = 'Find buffers' })
    vim.keymap.set('n', ',h', builtin.help_tags, { desc = 'Help tags' })
    vim.keymap.set('n', ',p', builtin.registers, { desc = 'Yank history' })
    vim.keymap.set('n', ',c', builtin.colorscheme, { desc = 'Colorscheme' })
    telescope.load_extension('zoxide')
    vim.keymap.set('n', ',z', require('telescope').extensions.zoxide.list, { desc = 'Zoxide' })
    vim.keymap.set('n', ',r', require('telescope').extensions.frecency.frecency, { desc = 'Frecency' })
  end,
},
{
  'nvim-telescope/telescope-frecency.nvim',
  -- install the latest stable version
  version = "*",
  config = function()
    require("telescope").load_extension "frecency"
  end,
},
'jvgrootveld/telescope-zoxide',
{
  'nvim-telescope/telescope-fzf-native.nvim',
  build = 'make',
},
'reedes/vim-wheel',
{
  'simonmclean/triptych.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'nvim-tree/nvim-web-devicons', -- optional for icons
    'antosha417/nvim-lsp-file-operations' -- optional LSP integration
  },
  opts = {}, -- config options here
  keys = {
    { '<leader>-', ':Triptych<CR>' },
  },
  mappings = {
    -- Everything below is buffer-local, meaning it will only apply to Triptych windows
    show_help = 'g?',
    jump_to_cwd = '.',  -- Pressing again will toggle back
    nav_left = 'h',
    nav_right = { 'l', '<CR>' }, -- If target is a file, opens the file in-place
    open_hsplit = { '-' },
    open_vsplit = { '|' },
    open_tab = { '<C-t>' },
    cd = '<leader>cd',
    delete = 'd',
    add = 'a',
    copy = 'c',
    rename = 'r',
    rename_from_scratch = 'R',
    cut = 'x',
    paste = 'p',
    quit = 'q',
    toggle_hidden = '<leader>.',
    toggle_collapse_dirs = 'z',
  },
  extension_mappings = {},
  options = {
    dirs_first = true,
    show_hidden = false,
    collapse_dirs = true,
    line_numbers = {
      enabled = true,
      relative = false,
    },
    file_icons = {
      enabled = true,
      directory_icon = '',
      fallback_file_icon = ''
    },
    responsive_column_widths = {
      -- Keys are breakpoints, values are column widths
      -- A breakpoint means "when vim.o.columns >= x, use these column widths"
      -- Columns widths must add up to 1 after rounding to 2 decimal places
      -- Parent or child windows can be hidden by setting a width of 0
      ['0'] = { 0, 0.5, 0.5 },
      ['120'] = { 0.2, 0.3, 0.5 },
      ['200'] = { 0.25, 0.25, 0.5 },
    },
    highlights = { -- Highlight groups to use. See `:highlight` or `:h highlight`
      file_names = 'NONE',
      directory_names = 'NONE',
    },
    syntax_highlighting = { -- Applies to file previews
      enabled = true,
      debounce_ms = 100,
    },
    backdrop = 60, -- Backdrop opacity. 0 is fully opaque, 100 is fully transparent (disables the feature)
    transparency = 0, -- 0 is fully opaque, 100 is fully transparent
    border = 'single', -- See :h nvim_open_win for border options
    max_height = 45,
    max_width = 220,
    margin_x = 4, -- Space left and right
    margin_y = 4, -- Space above and below
  },
  git_signs = {
    enabled = true,
    signs = {
      -- The value can be either a string or a table.
      -- If a string, will be basic text. If a table, will be passed as the {dict} argument to vim.fn.sign_define
      -- If you want to add color, you can specify a highlight group in the table.
      add = '+',
      modify = '~',
      rename = 'r',
      untracked = '?',
    },
  },
  diagnostic_signs = {
    enabled = true,
  }
},
{
  'antosha417/nvim-lsp-file-operations',
  dependencies = {
    'nvim-lua/plenary.nvim',
  -- Uncomment whichever supported plugin(s) you use
  -- 'nvim-tree/nvim-tree.lua',
  -- 'nvim-neo-tree/neo-tree.nvim',
  'simonmclean/triptych.nvim'
  },
  config = function()
    require('lsp-file-operations').setup()
  end,
},

-----------------------------------------------------------------------------------------}}}
--{{{ System
'MunifTanjim/nui.nvim',
{
  "vhyrro/luarocks.nvim",
  priority = 10000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
  config = true,
  opts = {
    rocks = { "hererocks" }, -- specifies a list of rocks to install
    -- luarocks_build_args = { "--with-lua=/my/path" }, -- extra options to pass to luarocks's configuration script
  },
},
'nvim-lua/plenary.nvim',
'folke/trouble.nvim',
{
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    -- dashboard = { enabled = true },
    -- explorer = { enabled = true },
    -- indent = { enabled = true },
    -- input = { enabled = true },
    -- picker = { enabled = true },
    -- notifier = { enabled = true },
    quickfile = { enabled = true },
    -- scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
},

-----------------------------------------------------------------------------------------}}}
--{{{ Syntax and LSP
-- 'neovim/nvim-lsp',
'neovim/nvim-lspconfig',
{
  'nvimdev/lspsaga.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lspsaga').setup({ 
      lightbulb = { enable = false, }
    })
    vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', { desc = 'LSP Hover Doc' })
    vim.keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', { desc = 'LSP Code Action' })
    vim.keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', { desc = 'LSP Rename' })
    vim.keymap.set('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', { desc = 'LSP Go to Definition' })
    vim.keymap.set('n', 'gD', '<cmd>Lspsaga peek_definition<CR>', { desc = 'LSP Peek Definition' })
  end,
},
{
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  config = function()
    require'nvim-treesitter.configs'.setup {
      ensure_installed = { "bash", "css", "gitignore", "graphql", "html", "javascript", "json", "julia", "lua", "markdown", "markdown_inline", "query", "regex", "tsx", "typescript", "vim", "vimdoc", "yaml" },
      sync_install = false,
      auto_install = false,
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["a="] = "@assignment.outer", ["i="] = "@assignment.inner",
            ["af"] = "@function.outer", ["if"] = "@function.inner",
            ["ab"] = "@block.outer", ["ib"] = "@block.inner",
            -- ["ap"] = "@parameter.outer", ["ip"] = "@parameter.inner",
            ["ac"] = "@call.outer", ["ic"] = "@call.inner",
            ["ao"] = "@class.outer", ["io"] = "@class.inner",
            ["aa"] = "@assignment.outer", ["ia"] = "@assignment.inner",
            ["it"] = "@comment.inner", ["at"] = "@comment.outer",
            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
          },
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = 'V',
          },
          include_surrounding_whitespace = true,
        },
      },
    }
  end,
},
'nvim-treesitter/nvim-treesitter-textobjects',
{
  'quarto-dev/quarto-nvim',
  dependencies = { 'jmbuhr/otter.nvim' },
  config = function()
    require('quarto').setup{
      lspFeatures = {
        languages = { "julia", "bash", "html" },
      },
    }
  end,
},
{
  'jose-elias-alvarez/null-ls.nvim',
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
            desc = "[lsp] format on save",
          })
        end
      end,
    })
  end,
},
{
  'MunifTanjim/prettier.nvim',
  config = function()
    require("prettier").setup({
      bin = 'prettier',
      filetypes = { "css", "graphql", "html", "javascript", "javascriptreact", "json", "less", "markdown", "scss", "typescript", "typescriptreact", "yaml" },
    })
  end,
},
'stevearc/conform.nvim',

-----------------------------------------------------------------------------------------}}}
-- {{{ Language Specific
{
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {},
  config = function()
    require("typescript-tools").setup {
      -- on_attach = function() ... end,
      -- handlers = {},
      settings = {
        -- spawn additional tsserver instance to calculate diagnostics on it
        separate_diagnostic_server = true,
        -- "change"|"insert_leave" determine when the client asks the server about diagnostic
        publish_diagnostic_on = "insert_leave",
        -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
        -- "remove_unused_imports"|"organize_imports") -- or string "all"
        -- to include all supported code actions
        -- specify commands exposed as code_actions
        expose_as_code_action = {},
        -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
        -- not exists then standard path resolution strategy is applied
        tsserver_path = nil,
        -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
        -- (see 💅 `styled-components` support section)
        tsserver_plugins = {},
        -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
        -- memory limit in megabytes or "auto"(basically no limit)
        tsserver_max_memory = "auto",
        -- described below
        tsserver_format_options = {},
        tsserver_file_preferences = {},
        -- locale of all tsserver messages, supported locales you can find here:
        -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
        tsserver_locale = "en",
        -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        -- CodeLens
        -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
        -- possible values: ("off"|"all"|"implementations_only"|"references_only")
        code_lens = "off",
        -- by default code lenses are displayed on all referencable values and for some of you it can
        -- be too much this option reduce count of them by removing member references from lenses
        disable_member_code_lens = true,
        -- JSXCloseTag
        -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
        -- that maybe have a conflict if enable this feature. )
        jsx_close_tag = {
          enable = false,
          filetypes = { "javascriptreact", "typescriptreact" },
        }
      },
    }
  end
},
'kdheepak/cmp-latex-symbols',
-- {
--     "OXY2DEV/markview.nvim",
--     lazy = false,
--     -- Completion for `blink.cmp`
--     -- dependencies = { "saghen/blink.cmp" },
-- },

-----------------------------------------------------------------------------------------}}}
--{{{ Misc
{
  'rbong/vim-crystalline',
  init = function()
    vim.g.crystalline_auto_prefix_groups = 1
    vim.g.crystalline_theme = 'nord'
  end,
  config = function()
    vim.cmd([[
      let g:crystalline_loaded=1
      function! g:GroupSuffix()
        if mode() ==# 'i' && &paste | return '2' | 
        endif
        if &modified | return '1' | 
        endif
        return ''
      endfunction
      function! g:CrystallineStatuslineFn(winnr)
        let g:crystalline_group_suffix = g:GroupSuffix()
        let l:curr = a:winnr == winnr()
        let l:s = ''
        if l:curr
          let l:s .= crystalline#ModeSection(0, 'A', 'B')
        else
          let l:s .= crystalline#HiItem('Fill')
        endif
          let l:s .= ' %f%h%w%m%r '
        if l:curr && exists('*fugitive#Head')
          let l:s .= crystalline#Sep(0, 'B', 'Fill') . ' %{fugitive#Head()}'
        endif
        let l:s .= '%='
        if l:curr
          let l:s .= crystalline#Sep(1, 'Fill', 'B') . '%{&paste ? " PASTE " : " "}'
          let l:s .= crystalline#Sep(1, 'B', 'A')
        endif
        if winwidth(a:winnr) > 80
          let l:s .= ' %{&ft} %l/%L %2v '
        else
          let l:s .= ' '
        endif
          return l:s
      endfunction
      function! g:CrystallineTablineFn()
        let l:max_width = &columns
        let l:right = '%='
        let l:right .= crystalline#Sep(1, 'TabFill', 'TabType')
        let l:max_width -= 1
        let l:vimlabel = has('nvim') ? ' nvim ' : ' VIM '
        let l:right .= l:vimlabel
        let l:max_width -= strchars(l:vimlabel)
        let l:max_tabs = 23
        return crystalline#TabsOrBuffers({
          \ 'enable_sep': 1,
          \ 'max_tabs': l:max_tabs,
          \ 'max_width': l:max_width
          \ }) . l:right
      endfunction
      set statusline=%!g:CrystallineStatuslineFn(winnr())
      set tabline=%!g:CrystallineTablineFn()
      set showtabline=2
      set laststatus=2
    ]])
  end,
},
{
  'kana/vim-textobj-user',
  config = function()
    vim.cmd([[
    call textobj#user#plugin('line', {
      \   '-': {
        \     'select-a-function': 'CurrentLineA',
        \     'select-a': 'al',
        \     'select-i-function': 'CurrentLineI',
        \     'select-i': 'il',
        \   },
        \ })
      function! CurrentLineA()
      normal! 0
      let head_pos = getpos('.')
      normal! $
      let tail_pos = getpos('.')
      return ['v', head_pos, tail_pos]
      endfunction
      function! CurrentLineI()
      normal! ^
      let head_pos = getpos('.')
      normal! g_
      let tail_pos = getpos('.')
      let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
      return non_blank_char_exists_p ? ['v', head_pos, tail_pos] : 0
      endfunction
    ]])
  end,
},
{
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup()
  end
},
{
  'milanglacier/yarepl.nvim',
  config = function()
    require("yarepl").setup {
      -- see `:h buflisted`, whether the REPL buffer should be buflisted.
      buflisted = true,
      -- whether the REPL buffer should be a scratch buffer.
      scratch = true,
      -- the filetype of the REPL buffer created by `yarepl`
      ft = 'REPL',
      -- How yarepl open the REPL window, can be a string or a lua function.
      -- See below example for how to configure this option
      wincmd = 'belowright 25 split',
      -- The available REPL palattes that `yarepl` can create REPL based on.
      -- To disable a built-in meta, set its key to `false`, e.g., `metas = { R = false }`
      metas = {
          aichat = { cmd = 'aichat', formatter = 'bracketed_pasting', source_syntax = 'aichat' },
          radian = { cmd = 'radian', formatter = 'bracketed_pasting_no_final_new_line', source_syntax = 'R' },
          ipython = { cmd = 'ipython', formatter = 'bracketed_pasting', source_syntax = 'ipython' },
          python = { cmd = 'python', formatter = 'trim_empty_lines', source_syntax = 'python' },
          R = { cmd = 'R', formatter = 'trim_empty_lines', source_syntax = 'R' },
          julia = { cmd = 'julia', formatter = 'trim_empty_lines', source_syntax = 'julia' },
          julia_allocs = { cmd = 'julia --track-allocations=all', formatter = 'trim_empty_lines', source_syntax = 'julia' },
          bash = {
              cmd = 'bash',
              formatter = vim.fn.has 'linux' == 1 and 'bracketed_pasting' or 'trim_empty_lines',
              source_syntax = 'bash',
          },
          zsh = { cmd = 'zsh', formatter = 'bracketed_pasting', source_syntax = 'bash' },
      },
      -- when a REPL process exits, should the window associated with those REPLs closed?
      close_on_exit = true,
      -- whether automatically scroll to the bottom of the REPL window after sending
      -- text? This feature would be helpful if you want to ensure that your view
      -- stays updated with the latest REPL output.
      scroll_to_bottom_after_sending = true,
      -- Format REPL buffer names as #repl_name#n (e.g., #ipython#1) instead of using terminal defaults
      format_repl_buffers_names = true,
      -- Display the first line as virtual text to indicate the actual
      -- command sent to the REPL.
      source_command_hint = {
          enabled = false,
          hl_group = 'Comment',
      },
    }

    vim.keymap.set('n', '<leader>rj', ':REPLStart julia<cr>')
    vim.keymap.set('n', '<leader>rr', '<Plug>(REPLHideOrFocus)')
    vim.keymap.set('n', '<leader>rc', '<Plug>(REPLClose)')
    vim.keymap.set('n', '<leader>sl', '<Plug>(REPLSendLine)')
    vim.keymap.set('n', '<leader>ss', '<Plug>(REPLSendOperator)')
    vim.keymap.set('v', '<leader>ss', '<Plug>(REPLSendVisual)')

  end,
},
'andythigpen/nvim-coverage',

-----------------------------------------------------------------------------------------}}}

}


