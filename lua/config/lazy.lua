-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- =====================================================================
-- Lazy.nvim setup
-- =====================================================================

require("lazy").setup({
    spec = {

        -- ========================
        -- Treesitter
        -- ========================
        {
            "nvim-treesitter/nvim-treesitter",
            lazy = false,
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter").setup({
                    auto_install = false,
                    ensure_installed = {
                        "c", "cpp", "cmake", "glsl", "python", "rust",
                        "lua", "vim", "vimdoc", "java", "kotlin",
                        "javascript", "html", "css", "markdown",
                        "json", "xml", "yaml", "toml", "latex",
                    },
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end,
        },

        -- ========================
        -- LSP (Neovim 0.11+)
        -- ========================
        {
            "neovim/nvim-lspconfig",
            lazy = false,
        },

        -- ========================
        -- Telescope
        -- ========================
        --{
        --    "nvim-telescope/telescope.nvim",
        --    branch = "0.1.x",
        --    dependencies = { "nvim-lua/plenary.nvim" },
        --},

        -- ========================
        -- Snippets
        -- ========================
        {
            "L3MON4D3/LuaSnip",
            build = "make install_jsregexp",
            dependencies = { "rafamadriz/friendly-snippets" },
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },

        -- ========================
        -- Completion
        -- ========================
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-path",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
            },
            config = function()
                local cmp = require("cmp")

                cmp.setup({
                    completion = {
                        keyword_length = 2,
                        max_item_count = 8,
                        completeopt = "menu,menuone,noinsert",
                    },
                    mapping = {
                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                        ["<C-j>"] = cmp.mapping.select_next_item(),
                        ["<C-k>"] = cmp.mapping.select_prev_item(),
                        ["<C-f>"] = cmp.mapping.scroll_docs(4),
                        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    },
                    sources = {
                        { name = "nvim_lsp", keyword_length = 4, max_item_count = 4 },
                        { name = "path",     keyword_length = 4, max_item_count = 4 },
                        { name = "luasnip",  keyword_length = 2, max_item_count = 8 },
                    },
                    snippet = {
                        expand = function(args)
                            require("luasnip").lsp_expand(args.body)
                        end,
                    },
                })
            end,
        },

        -- ========================
        -- Typst
        -- ========================
        {
            "chomosuke/typst-preview.nvim",
            ft = "typst",
            version = "1.*",
            opts = {},
        },

        -- ========================
        -- Colorscheme
        -- ========================
        {
            "folke/tokyonight.nvim",
            lazy = false,
            priority = 1000,
            config = function()
                vim.cmd.colorscheme("tokyonight")
            end,
        },
    },

    checker = { enabled = true },
})

-- =====================================================================
-- Native LSP configuration (Neovim 0.11+)
-- =====================================================================

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config.ruff = {
    capabilities = capabilities,
    configurationPreference = "filesystemFirst",
}

vim.lsp.config.clangd = {
    capabilities = capabilities,
}

vim.lsp.enable({ "ruff", "clangd" })
