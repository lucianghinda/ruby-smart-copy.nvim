# ruby-smart-copy.nvim

A Neovim plugin for intelligently copying Ruby methods with their class context and schema information.

This plugin was generated mostly with Claude Code.

## Features

- Copy Ruby methods with their surrounding class context
- Automatically includes ActiveRecord schema information (from `annotate` gem)
- Currently uses Tree-sitter for accurate Ruby syntax parsing
- Includes relative file path for easy reference
- Simple keymap for quick access

## Requirements

- Neovim >= 0.9.0
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with Ruby parser installed

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "lucianghinda/ruby-smart-copy.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("ruby-smart-copy").setup({
      keymap = "<leader>rc", -- Optional: customize keymap (default: <leader>rc)
      desc = "Smart copy Ruby method", -- Optional: customize description
    })
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "lucianghinda/ruby-smart-copy.nvim",
  requires = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("ruby-smart-copy").setup()
  end,
}
```

### Local installation

If you want to use this as a local plugin:

```lua
{
  dir = "~/ruby-smart-copy.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("ruby-smart-copy").setup()
  end,
}
```

## Usage

1. Open a Ruby file with a class and method
2. Place your cursor anywhere inside a method
3. Press `<leader>rc` (or your custom keymap)
4. The method context is copied to your clipboard!

You can also use the command:
```vim
:RubySmartCopy
```

## Example Output

Given this Ruby file:

```ruby
# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  admin               :boolean          default(FALSE), not null
#  email               :string           indexed
#  name                :string

class User
  def full_name
    "#{first_name} #{last_name}"
  end
end
```

When you use `<leader>rc` inside the `full_name` method, it copies:

```ruby
# file_path: app/models/user.rb
# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  admin               :boolean          default(FALSE), not null
#  email               :string           indexed
#  name                :string

class User
  def full_name
    "#{first_name} #{last_name}"
  end
end
```

## Configuration

The default configuration:

```lua
{
  keymap = "<leader>rc",
  desc = "Smart copy Ruby method",
}
```

You can customize these options in the `setup()` function.

## Platform Support

Currently supports macOS clipboard (`pbcopy`). Support for other platforms (Linux/Windows) can be added by detecting the clipboard command.

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
