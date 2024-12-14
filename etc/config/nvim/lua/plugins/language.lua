-- vim-markdown-toc settings
vim.g.vmt_fence_text = 'TOC START'
vim.g.vmt_fence_closing_text = 'TOC END'

-- obsidian.nvim settings
vim.opt.conceallevel = 1

return {

    -- hive
    { 'autowitch/hive.vim' },

    { 'mzlogin/vim-markdown-toc' },
    {
        'iamcco/markdown-preview.nvim',
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" }
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('render-markdown').setup({
                render_modes = { 'n', 'c', 't', 'i' },
                heading = {
                    sign = false,
                    icons = {},
                },
                code = {
                    sign = false,
                    language_name = false

                },
                indent = {
                    enabled = true
                }
            })
        end
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",

        },
        opts = {
            ui = {
                bullets = {},
            },
            workspaces = {
                {
                    name = "buf-parent",
                    path = function()
                        return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
                    end,
                },
            }
        },
    },

    -- python
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", --optional
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
        },
        lazy = false,
        branch = "regexp", -- This is the regexp branch, use this for the new version
        config = function()
            require("venv-selector").setup()
        end,
        keys = {
            { ",v", "<cmd>VenvSelect<cr>" },
        },
    },

    -- terraform
    { 'hashivim/vim-terraform' },
    { 'juliosueiras/vim-terraform-completion' },
}
