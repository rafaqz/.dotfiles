-- lua/mappings.lua
-- Key mappings, translated from mapping.vim

local map = vim.keymap.set

--{{{ General Leader mappings
map("n", "<leader><cr>", ":noh<cr>", { silent = true, desc = "Clear search highlight" })
map("n", "<leader>m", ":mark")
-- map("n", "<leader>o", ":set operatorfunc=OpenOperator<cr>g@", { desc = "Open with xdg-open" })

--}}}
--{{{ LSP
-- vim.keymap.set("n", "<silent> K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "LSP Hover" })
-- vim.keymap.set("n", "<silent> gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "LSP References" })
-- vim.keymap.set("n", "<silent> g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", { desc = "LSP Document Symbols" })

--}}} 
--{{{ Buffers
map("n", "<leader>ba", ":1,100 bd!<cr>", { desc = "Close all buffers" })
map("n", "<leader>bj", ":bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bk", ":bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bh", ":bfirst<cr>", { desc = "First buffer" })
map("n", "<leader>bl", ":blast<cr>", { desc = "Last buffer" })
map("n", "<leader>bo", "<c-w>o", { desc = "Close other windows" })
map("n", "<leader>bd", ":bd<cr>", { desc = "Delete buffer" })

--}}} 
--{{{ Git
map("n", "<leader>gb", ":Git blame<cr>", { desc = "Git blame" })
map("n", "<leader>gc", ":Gcommit<cr>", { desc = "Git commit" })
map("n", "<leader>ge", ":Extradite<cr>", { desc = "Git extradite" })
map("n", "<leader>gw", ":GBrowse<cr>", { desc = "Git browse" })
map("n", "<leader>gl", ":Git log<cr>", { desc = "Git log" })
map("n", "<leader>go", ":Git checkout<space>", { desc = "Git checkout" })
map("n", "<leader>gs", ":Git status<cr>", { desc = "Git status" })
-- map("n", "<leader>gg", ":GitGutterToggle<cr>", { desc = "Toggle Git Gutter" })
-- map("n", "<leader>gga", ":GitGutterStageHunk<cr>", { desc = "Stage hunk" })
-- map("n", "<leader>ggd", ":GitGutterPreviewHunk<cr>", { desc = "Preview hunk" })
-- map("n", "<leader>ggh", ":GitGutterLineHighlightsToggle<cr>", { desc = "Toggle line highlights" })
map("x", "dp", ":diffput<cr>", { desc = "Diff put" })
map("x", "do", ":diffget<cr>", { desc = "Diff get" })

--}}} 
--{{{ UI Toggles
map("n", "<leader>h", ":call ToggleHideAll()<cr>", { desc = "Toggle UI visibility" })
map("n", "<leader>i", ":call ToggleBackground()<cr>", { desc = "Toggle background color" })
map("n", "<Leader>ll", ":Twilight<cr>", { desc = "Toggle Twilight" })
map("n", "<leader>z", ":Goyo<cr>", { desc = "Toggle Goyo (zen mode)" })

--}}} 
--{{{ Clipboard
map("n", "<leader>po", '"*p', { desc = "Paste from system clipboard" })
map("n", "<leader>pp", '"+p', { desc = "Paste from primary clipboard" })
map("n", "<leader>Po", '"*P', { desc = "Paste before from system clipboard" })
map("n", "<leader>Pp", '"+P', { desc = "Paste before from primary clipboard" })
map("v", "<leader>d", '"+d', { desc = "Delete to primary clipboard" })
map("n", "<leader>p", '"+p', { desc = "Paste from primary clipboard" })
map("n", "<leader>P", '"+P', { desc = "Paste before from primary clipboard" })
map("v", "<leader>p", '"+p', { desc = "Paste from primary clipboard" })
map("v", "<leader>P", '"+P', { desc = "Paste before from primary clipboard" })
map("v", "<leader>y", '"+y', { desc = "Yank to primary clipboard" })
map("n", "<leader>Y", '"+yg_', { desc = "Yank line to primary clipboard" })
map("n", "<leader>y", '"+y', { desc = "Yank to primary clipboard" })
map("n", "<leader>yy", '"+yy', { desc = "Yank line to primary clipboard" })

--}}} 
--{{{ File formatting
map("n", "<leader>dm", "mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm", { desc = "Remove DOS line endings" })
map("n", "<leader>dw", ":call DeleteTrailingWS()<cr>", { desc = "Delete trailing whitespace" })
map("n", "<leader>de", [[:%s///g<cr>]], { desc = "Delete search pattern" })

--}}} 
--{{{ Ranger
map("n", "<leader>fc", ":set operatorfunc=RangerChangeOperator<cr>g@", { desc = "Ranger: change directory" })
map("n", "<leader>fR", ":set operatorfunc=RangerBrowseEdit<cr>g@", { desc = "Ranger: browse and edit" })
map("n", "<leader>fT", ":set operatorfunc=RangerBrowseTab<cr>g@", { desc = "Ranger: browse in new tab" })
map("n", "<leader>fS", ":set operatorfunc=RangerBrowseSplit<cr>g@", { desc = "Ranger: browse in split" })
map("n", "<leader>fV", ":set operatorfunc=RangerBrowseVSplit<cr>g@", { desc = "Ranger: browse in vertical split" })
map("n", "<leader>fi", ":RangerInsert<cr>", { desc = "Ranger: insert path" })
map("n", "<leader>fa", ":RangerAppend<cr>", { desc = "Ranger: append path" })
map("n", "<leader>ff", ":RangerEdit<cr>", { desc = "Ranger: edit file" })
map("n", "<leader>fv", ":RangerVSplit<cr>", { desc = "Ranger: vertical split" })
map("n", "<leader>fs", ":RangerSplit<cr>", { desc = "Ranger: split" })
map("n", "<leader>ft", ":RangerTab<cr>", { desc = "Ranger: new tab" })
map("n", "<leader>fd", ":RangerCD<cr>", { desc = "Ranger: change directory" })
map("n", "<leader>fl", ":RangerLCD<cr>", { desc = "Ranger: local change directory" })

--}}} 
--{{{ Text manipulation
map("v", "<leader>ti", [[:s/\<\(\\w\)\(\\w*\)>/\[u\1\L\2/g<cr>]], { desc = "Title case selection" })
map("n", "<leader>tc", ":call ConcealToggle()<cr>", { desc = "Toggle conceal" })
map("n", "<leader>tu", ":UndotreeToggle<cr>", { desc = "Toggle undo tree" })
map("n", "<leader>tw", ":set wrap!<cr>", { desc = "Toggle wrap" })
map("n", "<leader>td", ":filetype detect<cr>", { desc = "Detect filetype" })

--}}} 
--{{{ Tabs
map("n", "tt", ":call TabToggle()<cr>", { desc = "Toggle tabline" })
map("n", "ts", ":tabs<cr>", { desc = "List tabs" })
map("n", "th", ":silent! :tabfirst<cr>", { desc = "First tab" })
map("n", "tk", ":silent! :tabnext<cr>", { desc = "Next tab" })
map("n", "tj", ":silent! :tabprev<cr>", { desc = "Previous tab" })
map("n", "tl", ":silent! :tablast<cr>", { desc = "Last tab" })
map("n", "tm", ":tabmove<Space>", { desc = "Move tab" })
map("n", "td", ":tabclose<cr>", { desc = "Close tab" })
map("n", "tn", ":tabnew<cr>", { desc = "New tab" })
map("n", "tN", ":tabnew#<cr>", { desc = "New tab with buffer" })
map("n", "to", ":tabonly<cr>", { desc = "Only this tab" })
map("n", "tc", ":tabclose<cr>", { desc = "Close tab" })
map("n", "tJ", ":tabmove -1<cr>", { desc = "Move tab left" })
map("n", "TJ", ":tabmove -1<cr>", { desc = "Move tab left" })
map("n", "tK", ":tabmove +1<cr>", { desc = "Move tab right" })
map("n", "TK", ":tabmove +1<cr>", { desc = "Move tab right" })
map("n", "tL", ":tabmove $", { desc = "Move tab to end" })
map("n", "TL", ":tabmove $", { desc = "Move tab to end" })
map("n", "tH", ":tabmove 0<cr>", { desc = "Move tab to start" })
map("n", "TH", ":tabmove 0<cr>", { desc = "Move tab to start" })
map("n", "<silent>t]", "<C-w><C-]>C-w>T", { desc = "Go to tag in new tab" })

--}}} 
--{{{ Other Mappings
map("n", "Q", "<nop>")
map("n", "]]", ":cnext<cr>", { desc = "Next quickfix item" })
map("n", "[[", ":cprevious<cr>", { desc = "Previous quickfix item" })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("v", "<silent> *", ":call VisualSelection('f', '')<cr>", { desc = "Search for selection" })
map("v", "<silent> #", ":call VisualSelection('b', '')<cr>", { desc = "Search backwards for selection" })

--}}} 
--{{{ Window navigation
map("n", "<C-J>", "<C-W><C-J>", { desc = "Move to window below" })
map("n", "<C-K>", "<C-W><C-K>", { desc = "Move to window above" })
map("n", "<C-L>", "<C-W><C-L>", { desc = "Move to window right" })
map("n", "<C-H>", "<C-W><C-H>", { desc = "Move to window left" })

--}}} 
--{{{ Terminal mappings
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
--}}} 
