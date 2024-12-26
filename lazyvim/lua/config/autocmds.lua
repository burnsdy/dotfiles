-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Set <leader>* keymap to bold current line or selection in Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown", -- Only apply to Markdown files
  callback = function()
    vim.keymap.set("n", "<leader>*", function()
      vim.cmd("normal _wv$gsa*v$gsa*")
    end, { buffer = true, desc = "Bold current line in Markdown" })
    vim.keymap.set("v", "<leader>*", function()
      vim.cmd("normal <esc>gvgsa*gvgsa*")
    end, { buffer = true, desc = "Bold current line in Markdown" })
  end,
})
