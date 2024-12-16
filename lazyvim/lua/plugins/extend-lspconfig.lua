return {
  "neovim/nvim-lspconfig",
  opts = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    keys[#keys + 1] = { "K", vim.NIL }
    keys[#keys + 1] = {
      -- Originally set to "K", use "gK" if issues
      "gk",
      function()
        return vim.lsp.buf.hover()
      end,
      desc = "Hover",
    }
    keys[#keys + 1] = {
      -- Unset <C-k> in insert mode to allow cmp <C-k> keymap
      "<C-k>",
      vim.NIL,
      mode = "i",
    }
  end,
}
