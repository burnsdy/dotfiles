return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          { "K", false },
          -- Originally set to "K", use "gK" if issues
          {
            "gk",
            function()
              return vim.lsp.buf.hover()
            end,
            desc = "Hover",
          },
          -- Unset <C-k> in insert mode to allow cmp <C-k> keymap
          { "<C-k>", false, mode = "i" },
        },
      },
      -- Mason-installed oxfmt auto-enables and formats markdown on save
      oxfmt = { enabled = false },
    },
  },
}
