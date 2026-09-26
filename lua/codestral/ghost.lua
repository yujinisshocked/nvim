local M = {}

local ns = vim.api.nvim_create_namespace("codestral_ghost")

local current_text = nil

local function clear()
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  current_text = nil
end

local function show(text)
  clear()

  if not text or text == "" then
    return
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local first_line = vim.split(text, "\n", {
    plain = true,
  })[1]

  if first_line == "" then
    return
  end

  vim.api.nvim_buf_set_extmark(0, ns, row, col, {
    virt_text = {
      { first_line, "Comment" },
    },
    virt_text_pos = "inline",
  })

  current_text = text
end

function M.has_completion()
  return current_text ~= nil and current_text ~= ""
end

function M.accept()
  if not M.has_completion() then
    return false
  end

  local text = current_text

  -- Capture the position before clearing the ghost text.
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local col = cursor[2]

  clear()

  -- blink.cmp runs this function under textlock.
  -- Defer the actual buffer modification until after
  -- the <Tab> mapping has finished.
  vim.defer_fn(function()
    if not vim.api.nvim_buf_is_valid(0) then
      return
    end

    if not vim.api.nvim_get_mode().mode:match("^i") then
      return
    end

    local lines = vim.split(text, "\n", {
      plain = true,
    })

    vim.api.nvim_buf_set_text(
      0,
      row,
      col,
      row,
      col,
      lines
    )

    local new_row = row + #lines - 1
    local new_col

    if #lines == 1 then
      new_col = col + #lines[1]
    else
      new_col = #lines[#lines]
    end

    vim.api.nvim_win_set_cursor(0, {
      new_row + 1,
      new_col,
    })
  end, 0)

  return true
end

function M.request()
  clear()

  require("codestral").complete(function(text)
    vim.schedule(function()
      if text and text ~= "" then
        show(text)
      end
    end)
  end)
end

function M.setup()
  vim.keymap.set("i", "<C-l>", function()
    M.request()
  end, {
    desc = "Codestral completion",
  })

  vim.api.nvim_create_autocmd({
    "TextChangedI",
    "InsertLeave",
  }, {
    callback = function(args)
      if args.event == "InsertLeave" then
        clear()
      end
    end,
  })
end

return M
