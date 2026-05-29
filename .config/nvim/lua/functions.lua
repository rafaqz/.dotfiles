-- lua/functions.lua
-- Custom vimscript functions, wrapped for compatibility.

vim.cmd([[
fun! VisualSelection(direction, extra_filter)
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
    call CmdLine("Ack \"" . l:pattern . "\" " )
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif
  let @/ = l:pattern
  let @" = l:saved_reg
endfun

fun! DeleteTrailingWS()
  exe "normal! mz"
  %s/\s\+$//ge
  exe "normal! `z"
endfun

fun! BufferIsEmpty()
    if line('$') == 1 && getline(1) == '' 
        return 1
    else
        return 0
    endif
endfun

function! DeleteEmptyBuffers()
    let [i, n; empty] = [1, bufnr('$')]
    while i <= n
        if bufexists(i) && bufname(i) == ''
            call add(empty, i)
        endif
        let i += 1
    endwhile
    if len(empty) > 0
        exe 'bdelete' join(empty)
    endif
endfunction

function! OpenOperator(type)
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  exec "!xdg-open " . shellescape(@@)
endfunction

fun! ConcealToggle()
  if &conceallevel
    set conceallevel=0
  else
    set conceallevel=2
  endif
endfun

" fun! TabToggle()
"   if &showtabline
"     silent set showtabline=0
"   else
"     silent set showtabline=1
"   endif
" endfun

" fun! Highlight_Overlength()
"   let bg = execute('set background')
"   if &buftype ==# 'terminal'
"   else
"     if bg =~ 'dark'
"       highlight OverLength ctermbg=0
"     else
"       highlight OverLength ctermbg=7
"     endif
"     match OverLength /\%>92c.*/
"   end
" endfun

fun! Highlight_EndOfBuffer()
  let bg = execute('set background')
  if bg =~ 'dark'
    highlight EndOfBuffer ctermfg=0 ctermbg=0
  else
    highlight EndOfBuffer ctermfg=7 ctermbg=7
  endif
endfun

fun! MyFoldText()
  let line = foldtext()
  let sub = substitute(substitute(substitute(line, '+', "\ue0b1", 'g'), 'lines: ', "", 'g'), '─', "", 'g')
  return sub
endfun! 
set foldtext=MyFoldText()

fun! ToggleHideAll()
  if !exists("s:hide_all")
    let s:hide_all = 0
  endif
  if s:hide_all  == 0
    let s:hide_all = 1
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd
    set nonumber
    set showtabline=0
    set foldcolumn=0
    hi FoldColumns ctermbg=none
    hi FoldColumns ctermfg=none
  else
    let s:hide_all = 0
    set showmode
    set ruler
    set laststatus=2
    set showtabline=1
    set showcmd
    set foldcolumn=0
    set number
    hi FoldColumns ctermbg=5
  endif
endfun

fun! ToggleBackground()
  let &background = ( &background == "dark"? "light" : "dark" )
  let b = system('darkman toggle')
  echo b
  redraw!
endfun

fun! TableGrid()
  let g:table_mode_corner="+"
  let g:table_mode_corner_corner="+"
  let g:table_mode_header_fillchar="="
endfun

fun! TablePipe()
  let g:table_mode_corner="|"
  let g:table_mode_corner_corner="|"
  let g:table_mode_header_fillchar="-"
endfun

command! ReverseLine call setline('.', join(reverse(split(getline('.'))))) 
]])
