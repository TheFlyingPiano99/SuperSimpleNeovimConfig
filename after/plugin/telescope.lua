require('telescope').setup{
    defaults = {
            winblend = 20  -- Make the Telescope window semi-transparent (0 = opaque, 100 = fully transparent)
    }
}

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fw', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
