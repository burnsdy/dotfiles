return {
  "ibhagwan/fzf-lua",
  opts = {
    oldfiles = {
      -- Include current buffers in oldfiles list
      include_current_session = true,
    },
    previewers = {
      builtin = {
        -- Don't add syntax highlighting to files larger than 100KB
        syntax_limit_b = 1024 * 100,
      },
    },
    files = {
      actions = {
        ["ctrl-i"] = { require("fzf-lua.actions").toggle_ignore },
        ["ctrl-h"] = { require("fzf-lua.actions").toggle_hidden },
      },
    },
    grep = {
      actions = {
        ["ctrl-i"] = { require("fzf-lua.actions").toggle_ignore },
        ["ctrl-h"] = { require("fzf-lua.actions").toggle_hidden },
      },
    },
  },
}
