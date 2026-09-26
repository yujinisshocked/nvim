return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-project.nvim",
    },
    config = function()
      require("telescope").load_extension("dap")
      require("telescope").load_extension("project")
    end,
  },
}

