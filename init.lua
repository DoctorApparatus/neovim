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
local term_opts = { silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "
local wk = require('which-key')

-- SPLIT NAVIGATION
keymap("n", "<C-h>", "<cmd>wincmd h<cr>", default_opts)
keymap("n", "<C-j>", "<cmd>wincmd j<cr>", default_opts)
keymap("n", "<C-k>", "<cmd>wincmd k<cr>", default_opts)
keymap("n", "<C-l>", "<cmd>wincmd l<cr>", default_opts)

-- FILE BROWSER
wk.register({
    ["<leader>e"] = { "<cmd>NeoTreeShowToggle<cr>", "open file browser" }
})
