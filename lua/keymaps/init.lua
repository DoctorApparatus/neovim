-- KEYMAPS
local keymap = vim.keymap.set
local default_opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Easier normal mode
keymap("i", "jk", "<ESC>", default_opts)
keymap("t", "jk", "<C-\\><C-n>", default_opts)

-- Increment / Decrement
keymap("n", "+", "<C-a>", { desc = "increment" })
keymap("n", "-", "<C-x>", { desc = "decrement" })

keymap({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
keymap({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
keymap({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })

-- Close current buffer and go to previous
keymap("n", "<leader>bd", "<cmd>bp|bd #<cr>", { desc = "close current buffer" })

keymap({ "n", "o", "x", "t" }, "<C-h>", "<cmd>lua require('tmux').move_left()<CR>", { desc = "Select left buffer" })
keymap({ "n", "o", "x", "t" }, "<C-j>", "<cmd>lua require('tmux').move_bottom()<CR>", { desc = "Select bottom buffer" })
keymap({ "n", "o", "x", "t" }, "<C-k>", "<cmd>lua require('tmux').move_top()<CR>", { desc = "Select top buffer" })
keymap({ "n", "o", "x", "t" }, "<C-l>", "<cmd>lua require('tmux').move_right()<CR>", { desc = "Select right buffer" })

keymap("n", "<leader>ca", "<cmd>lua require('actions-preview').code_actions()<CR>", { desc = "Code actions" })

keymap("n", "<leader>tf", "<cmd>Telescope find_files<cr>", { desc = "telescope: find file" })
keymap("n", "<leader>tg", "<cmd>Telescope live_grep<cr>", { desc = "telescope: live grep" })

keymap("n", "<leader>gc", "<cmd>Neogen<cr>", { desc = "neogen: create comment string" })

keymap("n", "<leader>e", "<cmd>Neotree<cr>", { desc = "neotree: open" })

keymap("n", "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = "harpoon: add mark" })
keymap("n", "<leader>hf", "<cmd>Telescope harpon_marks<cr>", { desc = "harpoon: find mark" })

keymap("n", "<leader>ol", "<cmd>Outline<cr>", { desc = "outline: open" })

keymap("n", "<leader>cr", "<cmd>Lspsaga rename<cr>", { desc = "lsp: rename" })

local vim = vim
local opt = vim.opt
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
