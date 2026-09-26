local M = {}

local function get_api_key()
  return vim.env.MISTRAL_API_KEY
end

local function get_context()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)

  local row = cursor[1] - 1
  local col = cursor[2]

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local prefix_lines = vim.list_slice(lines, 1, row)

  if lines[row + 1] then
    table.insert(prefix_lines, string.sub(lines[row + 1], 1, col))
  end

  local suffix_lines = {}

  if lines[row + 1] then
    table.insert(suffix_lines, string.sub(lines[row + 1], col + 1))
  end

  for i = row + 2, #lines do
    table.insert(suffix_lines, lines[i])
  end

  return table.concat(prefix_lines, "\n"), table.concat(suffix_lines, "\n")
end

function M.complete(callback)
  local api_key = get_api_key()

  if not api_key then
    callback(nil)
    return
  end

  local prefix, suffix = get_context()

  local body = vim.json.encode({
    model = "codestral-latest",
    prompt = prefix,
    suffix = suffix,
    max_tokens = 128,
    temperature = 0,
  })

  vim.system({
    "curl",
    "-s",
    "https://codestral.mistral.ai/v1/fim/completions",
    "-H",
    "Content-Type: application/json",
    "-H",
    "Authorization: Bearer " .. api_key,
    "-d",
    body,
  }, {
    text = true,
  }, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        callback(nil)
      end)
      return
    end

    local ok, response = pcall(vim.json.decode, result.stdout)

    if not ok or not response then
      vim.schedule(function()
        callback(nil)
      end)
      return
    end

    local text = response.choices
      and response.choices[1]
      and response.choices[1].message
      and response.choices[1].message.content

    vim.schedule(function()
      callback(text)
    end)
  end)
end

return M
