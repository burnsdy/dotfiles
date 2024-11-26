-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map({ "n", "v" }, "J", "10j", { desc = "Down 10 lines", silent = true, remap = true })
map({ "n", "v" }, "K", "10k", { desc = "Up 10 lines", silent = true, remap = true })
map("n", "<leader>j", "J")
