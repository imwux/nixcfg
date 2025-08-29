-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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

-- VIM Settings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.number = true
vim.o.guicursor = "n-v-i-c-ci-ve-sm:ver25,r-cr-o:hor20"
vim.o.undodir = os.getenv("HOME") .. "/.cache/vim-undodir"
vim.o.undofile = true
vim.o.termguicolors = true

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline",
            },
            config = function()
                local cmp = require("cmp")

                cmp.setup.cmdline(":", {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        { name = "path" },
                        { name = "cmdline" },
                    },
                })

                cmp.setup.cmdline("/", {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        { name = "buffer" }
                    }
                })

                cmp.setup({
                    sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                    }, {
                        { name = "buffer" },
                        { name = "path" },
                    }),
                    mapping = cmp.mapping.preset.insert({
                        ["<Down>"] = cmp.mapping.select_next_item(),
                        ["<Up>"] = cmp.mapping.select_prev_item(),
                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                        ["<C-Space>"] = cmp.mapping.complete(),
                    })
                })
            end
        },
        {
            'neovim/nvim-lspconfig',
            dependencies = {
                {'hrsh7th/nvim-cmp'},
                { 'j-hui/fidget.nvim', opts = {} },
            }
        },
        {
            "rebelot/kanagawa.nvim"
        }
    },
    checker = { enabled = true },
    ui = {
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            require = "🌙",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
})

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- LSPs
vim.lsp.enable('clangd')

-- Theme
vim.cmd("colorscheme kanagawa")
