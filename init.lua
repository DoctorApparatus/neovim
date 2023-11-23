-- Enable true color
vim.opt.termguicolors = true
vim.cmd([[set termguicolors]])

require('plugins/main')
require('autocommands/main')

vim.cmd [[set tabstop=4]]
vim.cmd [[set shiftwidth=4]]
vim.cmd [[set so=999]]

vim.o.ls = 2
vim.o.ch = 0
vim.o.completeopt = "menuone,noinsert,noselect"
vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 2
vim.opt.completeopt = { "menuone", "noselect" }
vim.conceallevel = 0
vim.opt.fileencoding = "utf-8"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.mouse = "a"
vim.opt.pumheight = 10
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.timeoutlen = 1000
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.writebackup = false
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.scrolloff = 8
vim.sidescrolloff = 8
vim.opt.shortmess:append "c"

-- KEYMAPS
local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
-- local term_opts = { silent = true }

vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "
keymap("i", "jk", "<ESC>", default_opts)
keymap("t", "jk", "<C-\\><C-n>", default_opts)

-- vim.keymap.set("n", "bd", function()
--     vim.cmd("NeoTreeClose")
--     vim.cmd("bd")
--     vim.cmd("NeoTreeReveal")
-- end, default_opts)

-- Increment / Decrement
vim.keymap.set("n", "+", "<C-a>")
vim.keymap.set("n", "-", "<C-x>")
