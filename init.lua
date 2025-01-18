-- Simple NeoVim editor configuration
-- As a Python LSP we use Ruff
-- As a C/C++ LSP we use clangd
-- For code highlighting we use nvim-treesitter
-- Our colorsheme of choice is Catppuccin

---------------------------------------------

-- EDITOR SETTINGS


local set = vim.opt

set.hidden = true           -- Allows you to switch between buffers without needing to save the changes in the current buffer first 
set.swapfile = false        -- Swap file creation
set.backup = false          -- Backup file creation when saving
set.hlsearch = true         -- Highlight search results
set.incsearch = true        -- Incremental search results
set.wrap = false            -- Wrap long lines
set.mouse = 'a'             -- Enable mouse usage in all modes
set.termguicolors = true    -- Enable 24-bit RGB color
set.scrolloff = 4           -- the minimum number of screen lines to keep above and below the cursor when scrolling through a buffer 
set.number = true           -- Enable line numbering
set.relativenumber = false  -- Absolute line numbering

set.tabstop = 4             -- The number of spaces that a tab character represents. This setting affects how tabs are displayed in the editor 
set.shiftwidth = 4          -- The number of spaces to use for each step of indentation 
set.softtabstop = 4         -- The number of spaces that a tab character represents when editing text
set.expandtab = true        -- Whether the tab key inserts spaces instead of a tab character.
                            -- When expandtab is enabled, pressing the tab key will insert a number of spaces equivalent to the tabstop value 
set.smartindent = true      -- Syntax/style reactive indenting

vim.opt.updatetime = 50     -- Fast update time

vim.g.netrw_winsize = 20    -- This option controls the size of the window used by netrw when it opens 
vim.g.netrw_banner = 1      -- Set netrw banner
vim.g.mapleader = " "       -- Leader key is space



---------------------------------------------

-- LAZY
require("config.lazy")
require("config.remap")


-- Transparent background:
-- (Comment out in case you don't want it!)
vim.cmd [[
  hi Normal guibg=NONE ctermbg=NONE
  hi NonText guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
  hi EndOfBuffer guibg=NONE ctermbg=NONE
]]

