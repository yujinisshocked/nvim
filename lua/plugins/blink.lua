return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",

        ["<Tab>"] = {
          function(cmp)
            local codestral = require("codestral.ghost")

            -- 1. Codestral ghost text gets highest priority
            if codestral.has_completion() then
              codestral.accept()
              return true
            end

            -- 2. Otherwise accept Blink completion
            if cmp.is_visible() then
              return cmp.select_and_accept()
            end

            -- 3. Otherwise insert a normal Tab
            return vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes(
                "<Tab>",
                true,
                true,
                true
              ),
              "n",
              true
            )
          end,
        },

        ["<S-Tab>"] = {
          "select_prev",
        },
      },
    },
  },
}
