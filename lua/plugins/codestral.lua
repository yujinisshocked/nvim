return {
  {
    "saghen/blink.cmp",

    opts = function(_, opts)
      vim.schedule(function()
        require("codestral.ghost").setup()
      end)

      return opts
    end,
  },
}
