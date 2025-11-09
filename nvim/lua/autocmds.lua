-- lua/autocmds.lua

--{{{ Add file's directory to zoxide on open
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local dir = vim.fn.expand('%:p:h')
    if dir and dir ~= '' and vim.fn.isdirectory(dir) == 1 then
      vim.fn.system("zoxide add " .. vim.fn.shellescape(dir))
    end
  end,
  desc = "Add file's directory to zoxide database",
})

--}}}
--{{{ Remember last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd("normal! g`\"")
    end
  end,
  desc = "Restore cursor to last known position",
})

--}}}
--{{{ Highlight end of buffer
vim.api.nvim_create_autocmd({"BufEnter", "ColorScheme"}, {
  pattern = "*",
  callback = function()
    vim.cmd("call Highlight_EndOfBuffer()")
  end,
  desc = "Highlight end of buffer",
})

--}}}
--{{{ Language Server
vim.lsp.config('julials', {
  cmd = {
    "julia",
    "--project=".."~/.julia/environments/lsp/",
    "--startup-file=no",
    "--history-file=no",
    "-e", [[
      using Pkg
      Pkg.instantiate()
      using LanguageServer
      depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
      project_path = dirname(something(
        ## 1. Finds an explicitly set project (JULIA_PROJECT)
        Base.load_path_expand((
          p = get(ENV, "JULIA_PROJECT", nothing);
          p === nothing ? nothing : isempty(p) ? nothing : p
        )),
        ## 2. Look for a Project.toml file in the current working directory,
        ##    or parent directories, with $HOME as an upper boundary
        Base.current_project(),
        ## 3. First entry in the load path
        get(Base.load_path(), 1, nothing),
        ## 4. Fallback to default global environment,
        ##    this is more or less unreachable
        Base.load_path_expand("@v#.#"),
      ))
      @info "Running language server" VERSION pwd() project_path depot_path
      server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
      server.runlinter = true
      run(server)
    ]]
  },
  filetypes = { 'julia' },
  root_markers = { "Project.toml", "JuliaProject.toml" },
  settings = {},
})

--}}}
--{{{ Diffview
vim.api.nvim_create_autocmd("User", {
  pattern = "DiffviewOpen",
  callback = function()
    require("lspsaga.winbar").disable()
  end,
  desc = "Disable lspsaga breadcrumbs in Diffview",
})
vim.api.nvim_create_autocmd("User", {
  pattern = "DiffviewClose",
  callback = function()
    require("lspsaga.winbar").enable()
  end,
  desc = "Enable lspsaga breadcrumbs after closing Diffview",
})
--}}}
--{{{ Filetypes
--All other filetype settings are wrapped in a vim.cmd block for 100% compatibility
vim.cmd([[
augroup filetype_settings
autocmd!

" Julia
autocmd FileType julia call SetJulia()
function! SetJulia()
  setl shiftwidth=4
  setl tabstop=4
  setl foldmethod=syntax
  setl textwidth=92
endfunction

" JavaScript
autocmd FileType javascript call SetJavaScript()
function! SetJavaScript()
  setl fen
  setl nocindent
  setl foldmethod=syntax
  syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
  function! FoldText()
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
  endfunction
endfunction

" Python
autocmd FileType python call SetPython()
function! SetPython()
  let python_highlight_all = 1
  syn keyword pythonDecorator True None False self
  setl foldmethod=indent
  setlocal omnifunc=jedi#completions
endfunction

" Vim
autocmd FileType vim set foldmethod=marker foldlevel=0 | setlocal keywordprg=:help
" Lua
autocmd FileType lua call SetLua()
function! SetLua() 
  setl foldmethod=marker foldlevel=0 | setlocal keywordprg=:help
  setl tabstop=2
endfunction

" R
autocmd FileType r,rmd call SetR()
function! SetR()
  setl shiftwidth=2
endfunction

" Markdown
autocmd FileType pandoc,markdown,mkd,jmd,rmd call SetMarkdown()
autocmd BufRead,BufNewFile *.jmd set filetype=markdown
function! SetMarkdown()
  setl shiftwidth=2
  setl tabstop=2
  setl textwidth=80
  setl commentstring=<!--\ %s\ -->
  setl foldlevel=1
  setl nowrap
endfunction

" Git
autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
]])

--}}}
