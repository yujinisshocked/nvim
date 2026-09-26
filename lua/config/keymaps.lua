-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Debugging
vim.keymap.set("n", "<F5>", "<cmd>FlutterDebug<CR>", { desc = "Start Flutter Debug" })
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end)
vim.keymap.set("n", "<leader>b", function() require("dap").toggle_breakpoint() end)

-- Go to definition (LSP)
vim.keymap.set("n", "<F12>", vim.lsp.buf.definition, { desc = "Go to definition" })

vim.g.mapleader = " "
vim.g.maplocalleader = " "



