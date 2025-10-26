local eq = assert.are.same
local plugin = require("ruby-smart-copy")

describe("ruby-smart-copy", function()
  before_each(function()
    plugin.setup()
  end)

  describe("when cursor is inside an instance method", function()
    it("copies instance method with schema information", function()
      -- Open the fixture file
      vim.cmd("edit tests/fixtures/user.rb")

      -- Move cursor to line 11 (inside full_name method)
      vim.api.nvim_win_set_cursor(0, { 11, 0 })

      -- Call the smart copy function
      plugin.smart_copy_ruby_method()

      -- Get clipboard content
      local clipboard = vim.fn.system("pbpaste")

      -- Verify the output contains expected elements
      assert.is_truthy(clipboard:match("# file_path: tests/fixtures/user.rb"))
      assert.is_truthy(clipboard:match("# == Schema Information"))
      assert.is_truthy(clipboard:match("class User"))
      assert.is_truthy(clipboard:match("def full_name"))
      assert.is_truthy(clipboard:match('"#{first_name} #{last_name}"'))
      assert.is_truthy(clipboard:match("end"))
    end)

    it("copies instance method without schema when schema is not present", function()
      vim.cmd("edit tests/fixtures/simple.rb")

      -- Move cursor to line 2 (inside add method)
      vim.api.nvim_win_set_cursor(0, { 2, 0 })

      plugin.smart_copy_ruby_method()

      local clipboard = vim.fn.system("pbpaste")

      assert.is_truthy(clipboard:match("# file_path: tests/fixtures/simple.rb"))
      assert.is_truthy(clipboard:match("class Calculator"))
      assert.is_truthy(clipboard:match("def add%(a, b%)"))
      assert.is_truthy(clipboard:match("a %+ b"))
      assert.is_falsy(clipboard:match("Schema Information"))
    end)
  end)

  describe("when cursor is inside a singleton method", function()
    it("copies class method defined with self.method_name syntax", function()
      vim.cmd("edit tests/fixtures/user.rb")

      -- Move cursor to line 15 (inside find_by_email method)
      vim.api.nvim_win_set_cursor(0, { 15, 0 })

      plugin.smart_copy_ruby_method()

      local clipboard = vim.fn.system("pbpaste")

      assert.is_truthy(clipboard:match("# file_path: tests/fixtures/user.rb"))
      assert.is_truthy(clipboard:match("# == Schema Information"))
      assert.is_truthy(clipboard:match("class User"))
      assert.is_truthy(clipboard:match("def self%.find_by_email%(email%)"))
      assert.is_truthy(clipboard:match("where%(email: email%)%.first"))
    end)

    it("copies class method with self.method_name from file without schema", function()
      vim.cmd("edit tests/fixtures/simple.rb")

      -- Move cursor to line 6 (inside multiply method)
      vim.api.nvim_win_set_cursor(0, { 6, 0 })

      plugin.smart_copy_ruby_method()

      local clipboard = vim.fn.system("pbpaste")

      assert.is_truthy(clipboard:match("class Calculator"))
      assert.is_truthy(clipboard:match("def self%.multiply%(a, b%)"))
      assert.is_truthy(clipboard:match("a %* b"))
    end)
  end)

  describe("when cursor is inside a class methods with explicit class name", function()
    it("copies class method defined with ClassName.method_name syntax", function()
      vim.cmd("edit tests/fixtures/user.rb")

      -- Move cursor to line 19 (inside create_with_defaults method)
      vim.api.nvim_win_set_cursor(0, { 19, 0 })

      plugin.smart_copy_ruby_method()

      local clipboard = vim.fn.system("pbpaste")

      assert.is_truthy(clipboard:match("# file_path: tests/fixtures/user.rb"))
      assert.is_truthy(clipboard:match("class User"))
      assert.is_truthy(clipboard:match("def User%.create_with_defaults%(email%)"))
      assert.is_truthy(clipboard:match("new%(email: email, admin: false%)"))
    end)

    it("copies class method with ClassName.method_name from file without schema", function()
      vim.cmd("edit tests/fixtures/simple.rb")

      -- Move cursor to line 10 (inside divide method)
      vim.api.nvim_win_set_cursor(0, { 10, 0 })

      plugin.smart_copy_ruby_method()

      local clipboard = vim.fn.system("pbpaste")

      assert.is_truthy(clipboard:match("class Calculator"))
      assert.is_truthy(clipboard:match("def Calculator%.divide%(a, b%)"))
      assert.is_truthy(clipboard:match("return nil if b%.zero%?"))
      assert.is_truthy(clipboard:match("a / b"))
    end)
  end)

  describe("error handling", function()
    it("prints error when invoked on non-Ruby files", function()
      -- Create a temporary non-Ruby file
      vim.cmd("enew")
      vim.bo.filetype = "lua"

      -- This should print an error message but not crash
      plugin.smart_copy_ruby_method()

      -- No assertion needed, just verify it doesn't crash
    end)

    it("prints error when cursor is not in a method", function()
      vim.cmd("edit tests/fixtures/simple.rb")

      -- Move cursor to line 1 (class definition line)
      vim.api.nvim_win_set_cursor(0, { 1, 0 })

      -- This should print an error message but not crash
      plugin.smart_copy_ruby_method()
    end)
  end)
end)
