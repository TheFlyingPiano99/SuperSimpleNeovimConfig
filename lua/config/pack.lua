-- Leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- =====================================================================
-- vim.pack setup (Neovim 0.12+)
-- =====================================================================

-- Build/update hooks; must be registered before vim.pack.add()
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if kind ~= "install" and kind ~= "update" then
            return
        end
        if name == "nvim-treesitter" then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            pcall(vim.cmd, "TSUpdate")
        elseif name == "LuaSnip" then
            vim.system({ "make", "install_jsregexp" }, { cwd = ev.data.path })
        end
    end,
})

local gh = function(repo) return "https://github.com/" .. repo end

vim.pack.add({
    -- Colorscheme
    gh("folke/tokyonight.nvim"),
    -- Treesitter
    gh("nvim-treesitter/nvim-treesitter"),
    -- LSP
    gh("neovim/nvim-lspconfig"),
    -- Snippets
    gh("rafamadriz/friendly-snippets"),
    gh("L3MON4D3/LuaSnip"),
    -- Completion
    gh("hrsh7th/nvim-cmp"),
    gh("hrsh7th/cmp-nvim-lsp"),
    gh("hrsh7th/cmp-path"),
    gh("saadparwaiz1/cmp_luasnip"),
    -- Typst
    { src = gh("chomosuke/typst-preview.nvim"), version = vim.version.range("1.*") },
})

-- ========================
-- Colorscheme
-- ========================
vim.cmd.colorscheme("tokyonight")

-- ========================
-- Treesitter
-- ========================
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

-- ========================
-- Snippets
-- ========================
require("luasnip.loaders.from_vscode").lazy_load()

-- ========================
-- Completion
-- ========================
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

-- ========================
-- Typst
-- ========================
require("typst-preview").setup({})

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
