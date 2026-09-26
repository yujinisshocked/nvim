local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      -- Disable snippet expansion
      -- vim.fn["vsnip#anonymous"](args.body) -- For vsnip users
      -- require('luasnip').lsp_expand(args.body) -- For luasnip users
      -- Do nothing here
    end,
  },
  -- ... rest of your config
})

