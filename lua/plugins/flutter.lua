return {
  {
    "nvim-flutter/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        flutter_path = "/home/yujin/develop/flutter/bin/flutter",
        lsp = {
          color = {
            enabled = true,
          },
        },
      })
    end,
  },
}
