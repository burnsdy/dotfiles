-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Remap <leader>; to save
map({ "n", "v" }, "<leader>;", "<cmd>nohlsearch<CR><cmd>write<cr>", { desc = "Save file", silent = true })

-- Remap J and K for navigation
map({ "n", "v" }, "J", "10j", { desc = "Scroll down 10 lines", silent = true, remap = true })
map({ "n", "v" }, "K", "10k", { desc = "Scroll up 10 lines", silent = true, remap = true })
map("n", "<leader>j", "J")

-- Remap <leader>v to visual select to end of line
map("n", "<leader>v", "v$", { desc = "Visual select to EOL", silent = true })

-- Remap <c-d> and <c-u> to scroll only 20 lines
map("n", "<c-d>", "20<c-e>", { desc = "Scroll down 20 lines", silent = true })
map("n", "<c-u>", "20<c-y>", { desc = "Scroll up 20 lines", silent = true })
