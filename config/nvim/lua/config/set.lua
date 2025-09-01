-- General
vim.opt.autoread = true -- auto reload files when changed outside of nvim
vim.opt.clipboard = 'unnamed,unnamedplus' -- use system keyboard for yank
vim.opt.incsearch = true -- incremental search
vim.opt.termguicolors = true  -- enable 24-bit RGB colors

-- UI
vim.opt.scrolloff = 8 -- keep lines above/below cursor when scrolling
vim.opt.sidescrolloff = 3 -- keep columns left/right of cursor when scrolling
vim.opt.ruler = true  -- show cursor position
vim.opt.number = true -- set line numbers

-- Text
vim.opt.smarttab = true  -- use smart tabbing
vim.opt.smartindent = true  -- use smart indenting
vim.opt.wrap = false  -- disable line wrapping
vim.opt.expandtab = true  -- convert tabs to spaces
vim.opt.tabstop = 4  -- tab size in spaces
vim.opt.softtabstop = 4  -- tab size when editing
vim.opt.shiftwidth = 4  -- number of spaces to use for each step of (auto)indent
