-- Auto-load plugin
if vim.g.loaded_ruby_smart_copy then
  return
end

vim.g.loaded_ruby_smart_copy = 1

-- Create a command for manual invocation
vim.api.nvim_create_user_command('RubySmartCopy', function()
  require('ruby-smart-copy').smart_copy_ruby_method()
end, { desc = 'Copy Ruby method with class context and schema info' })
