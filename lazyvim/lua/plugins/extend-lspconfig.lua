return {
  {
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
      -- keys[#keys + 1] = {
      --   "<leader>k",
      --   function()
      --     return vim.lsp.buf.signature_help()
      --   end,
      --   desc = "Signature Help",
      --   has = "signatureHelp",
      -- }
    end,
  },
}
