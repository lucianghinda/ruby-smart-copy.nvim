local M = {}

-- Default configuration
M.config = {
  keymap = "<leader>rc",
  desc = "Smart copy Ruby method",
}

-- Smart copy function for Ruby methods with schema info
function M.smart_copy_ruby_method()
  -- Check if we're in a Ruby file
  local filetype = vim.bo.filetype
  if filetype ~= "ruby" then
    print("Not a Ruby file")
    return
  end

  local parsers = require("nvim-treesitter.parsers")

  -- Get the parser for the current buffer
  local parser = parsers.get_parser()
  if not parser then
    print("No parser available")
    return
  end

  local tree = parser:parse()[1]
  local root = tree:root()

  -- Get cursor position
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row = cursor[1] - 1 -- Tree-sitter uses 0-indexed rows

  -- Find the method node at cursor
  local method_node = nil
  local class_node = nil

  -- Query to find method and class nodes
  local query_text = [[
    (method) @method
    (class) @class
  ]]

  local query = vim.treesitter.query.parse("ruby", query_text)

  -- Find the innermost method containing the cursor
  for id, node in query:iter_captures(root, 0) do
    local name = query.captures[id]
    local start_row, _, end_row, _ = node:range()

    if name == "method" and start_row <= cursor_row and cursor_row <= end_row then
      if not method_node or start_row > method_node:range() then
        method_node = node
      end
    end

    if name == "class" and start_row <= cursor_row and cursor_row <= end_row then
      if not class_node or start_row > class_node:range() then
        class_node = node
      end
    end
  end

  if not method_node then
    print("No method found at cursor")
    return
  end

  if not class_node then
    print("No class found at cursor")
    return
  end

  -- Get file path (relative to cwd)
  local file_path = vim.fn.expand("%")

  -- Get the full buffer content
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Extract schema information (look for comments at the top)
  local schema_info = {}
  local in_schema = false
  local schema_start = nil
  local schema_end = nil

  for i, line in ipairs(lines) do
    if line:match("^%s*#%s*==%s*Schema Information") then
      in_schema = true
      schema_start = i
    elseif in_schema then
      if line:match("^%s*class%s+") or line:match("^%s*module%s+") then
        schema_end = i - 1
        break
      elseif line:match("^%s*#") or line:match("^%s*$") then
        -- Continue collecting schema comments
      else
        -- Hit non-comment, non-class line
        schema_end = i - 1
        break
      end
    end
  end

  if schema_start and schema_end then
    for i = schema_start, schema_end do
      table.insert(schema_info, lines[i])
    end
  end

  -- Get class text
  local class_start_row, _, class_end_row, _ = class_node:range()

  -- Get method text with proper indentation
  local method_start_row, _, method_end_row, _ = method_node:range()
  local method_lines = vim.api.nvim_buf_get_lines(bufnr, method_start_row, method_end_row + 1, false)

  -- Get class name
  local class_line = lines[class_start_row + 1]
  local class_name = class_line:match("class%s+([%w:]+)")

  -- Build the output
  local output = {}
  table.insert(output, "# file_path: " .. file_path)

  -- Add schema information if exists
  if #schema_info > 0 then
    for _, line in ipairs(schema_info) do
      table.insert(output, line)
    end
  end

  table.insert(output, "class " .. class_name)

  -- Add method with proper indentation
  for _, line in ipairs(method_lines) do
    table.insert(output, "  " .. line)
  end

  table.insert(output, "end")

  -- Join output and copy to clipboard
  local result = table.concat(output, "\n")

  -- Copy to clipboard (macOS)
  vim.fn.system("pbcopy", result)

  print("Copied method with context!")
end

-- Setup function
function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", M.config, opts)

  -- Set up the keymap
  vim.keymap.set('n', M.config.keymap, M.smart_copy_ruby_method,
    { noremap = true, silent = true, desc = M.config.desc })
end

return M
