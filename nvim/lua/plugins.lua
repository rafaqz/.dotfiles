-- lua/plugins.lua
-- Plugin specifications for lazy.nvim

return {

-- {{{ Bling 
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
'nvim-tree/nvim-web-devicons',

'nvim-mini/mini.icons',
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
'tpope/vim-commentary',
'tpope/vim-unimpaired',
'dahu/vim-fanfingtastic',
'michaeljsmith/vim-indent-object',
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
{
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'petertriho/cmp-git',
    'hrsh7th/vim-vsnip',
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
        { name = 'git' },
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'cmdline_history' },
      })
    })
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({ { name = 'git' } }, { { name = 'buffer' } })
    })
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = 'buffer' } }
    })
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
    })
  end,
},

-----------------------------------------------------------------------------------------}}}
-- {{{ Git
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
    vim.keymap.set('n', '<leader>gdh', ':DiffviewOpen HEAD~')
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
    vim.keymap.set('n', ',f', function() require('telescope.builtin').find_files({ hidden = true }) end, { desc = 'Find files (including hidden)' })
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
-----------------------------------------------------------------------------------------}}}
--{{{ Misc
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
  'Vigemus/iron.nvim',
  config = function()
    require("iron.core").setup {
      config = {
        scratch_repl = false,
        repl_definition = {
          sh = { command = {"zsh"} },
          python = {
            command = { "python3" },
            format = require("iron.fts.common").bracketed_paste_python,
            block_dividers = { "# %%", "#%%" },
            env = {PYTHON_BASIC_REPL = "1"}
          },
          julia = {
            command = { "julia", "-t", "auto" },
            format = require("iron.fts.common").bracketed_paste,
          },
        },
        repl_filetype = function(bufnr, ft) return "iron" end,
        dap_integration = true,
        repl_open_cmd = require("iron.view").split.botright("%45"),
      },
      keymaps = {
        toggle_repl = "<space>rr",
        restart_repl = "<space>rR",
        send_motion = "<space>ss",
        visual_send = "<space>ss",
        send_file = "<space>sf",
        send_line = "<space>sl",
        send_paragraph = "<space>sp",
        send_until_cursor = "<space>su",
        send_mark = "<space>sm",
        send_code_block = "<space>sb",
        send_code_block_and_move = "<space>sn",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>s<cr>",
        interrupt = "<space>s<space>",
        exit = "<space>sq",
        clear = "<space>cl",
      },
      highlight = { italic = true },
      ignore_blank_lines = true,
    }
    vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>a')
    vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
    vim.keymap.set('v', '<space>sl', '<cmd>IronSend<cr>')
  end,
},
'andythigpen/nvim-coverage',
'nvim-lua/plenary.nvim',

-----------------------------------------------------------------------------------------
-- Syntax and LSP
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
            ["ap"] = "@parameter.outer", ["ip"] = "@parameter.inner",
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
    let l:vimlabel = has('nvim') ?  ' nvim ' : ' VIM '
    let l:right .= l:vimlabel
    let l:max_width -= strchars(l:vimlabel)
    let l:max_tabs = 23
    return crystalline#DefaultTabline({
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

}

