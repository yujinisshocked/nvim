vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "lua", "c", "cpp", "java", "dart" },
  callback = function()
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = false
    vim.opt_local.cindent = false
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.cinkeys:remove("0{,0},0),0#,!^F,o,O,e")
  end,
})

