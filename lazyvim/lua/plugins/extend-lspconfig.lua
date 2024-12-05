return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "K",
        function()
          -- return vim.NIL instead of false to ensure change is applied to all LSP
          return vim.NIL
        end,
      }
      keys[#keys + 1] = {
        "gK",
        function()
          return vim.lsp.buf.hover()
        end,
        desc = "Hover",
      }
      keys[#keys + 1] = {
        "<C-k>",
        function()
          return vim.lsp.buf.signature_help()
        end,
        desc = "Signature Help",
        has = "signatureHelp",
      }
    end,
  },
}
