#!/usr/bin/env bash

# Script to run tests using plenary.nvim

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running ruby-smart-copy.nvim tests...${NC}\n"

# Check if plenary.nvim is installed
if ! nvim --headless -c "lua if not pcall(require, 'plenary') then vim.cmd('cquit') end" -c "quit" 2>/dev/null; then
    echo -e "${RED}Error: plenary.nvim is not installed${NC}"
    echo "Please install plenary.nvim first:"
    echo "  https://github.com/nvim-lua/plenary.nvim"
    exit 1
fi

# Run the tests
nvim --headless -c "PlenaryBustedDirectory tests/ { minimal_init = 'tests/minimal_init.lua' }"

echo -e "\n${GREEN}Tests completed!${NC}"
