-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map({ "n", "v" }, "J", "10j", { desc = "Scroll down 10 lines", silent = true, remap = true })
map({ "n", "v" }, "K", "10k", { desc = "Scroll up 10 lines", silent = true, remap = true })
map("n", "<leader>j", "J")
