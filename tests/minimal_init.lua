-- Minimal init for testing

-- Add the current directory to the runtime path
vim.cmd [[set runtimepath=$VIMRUNTIME]]
vim.cmd [[set runtimepath+=.]]

-- Add plenary to the runtime path (adjust path as needed)
local plenary_path = vim.fn.stdpath("data") .. "/lazy/plenary.nvim"
if vim.fn.isdirectory(plenary_path) == 1 then
  vim.opt.runtimepath:append(plenary_path)
else
  -- Try common plugin manager paths
  local common_paths = {
    vim.fn.expand("~/.local/share/nvim/lazy/plenary.nvim"),
    vim.fn.expand("~/.local/share/nvim/site/pack/packer/start/plenary.nvim"),
    vim.fn.expand("~/.config/nvim/pack/vendor/start/plenary.nvim"),
  }

  for _, path in ipairs(common_paths) do
    if vim.fn.isdirectory(path) == 1 then
      vim.opt.runtimepath:append(path)
      break
    end
  end
end

-- Add nvim-treesitter to the runtime path
local treesitter_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter"
if vim.fn.isdirectory(treesitter_path) == 1 then
  vim.opt.runtimepath:append(treesitter_path)
else
  -- Try common plugin manager paths
  local common_paths = {
    vim.fn.expand("~/.local/share/nvim/lazy/nvim-treesitter"),
    vim.fn.expand("~/.local/share/nvim/site/pack/packer/start/nvim-treesitter"),
    vim.fn.expand("~/.config/nvim/pack/vendor/start/nvim-treesitter"),
  }

  for _, path in ipairs(common_paths) do
    if vim.fn.isdirectory(path) == 1 then
      vim.opt.runtimepath:append(path)
      break
    end
  end
end

-- Require plenary for testing
vim.cmd [[runtime! plugin/plenary.vim]]
