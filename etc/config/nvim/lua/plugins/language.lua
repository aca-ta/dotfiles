-- vim-markdown settings
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_conceal = 1
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_markdown_new_list_item_indent = 0

-- vim-markdown-toc settings
vim.g.vmt_fence_text = 'TOC START'
vim.g.vmt_fence_closing_text = 'TOC END'


return {

    -- hive
    { 'autowitch/hive.vim' },

    -- markdown
    {
        'plasticboy/vim-markdown',
        dependencies = { 'godlygeek/tabular' },
    },
    { 'mzlogin/vim-markdown-toc' },
    {
        'iamcco/markdown-preview.nvim',
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
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
                -- \22 はvisual mode
                -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/188
                render_modes = { 'n', 'c', 't', 'i', '\22', },
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
                bullets = {}
            },
            follow_url_func = function(url)
                -- Use the default web browser to open the URL
                -- macの場合
                vim.fn.jobstart({ "open", url }, { detach = true })
            end,
            workspaces = {
                {
                    name = "buf-parent",
                    path = function()
                        return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
                    end,
                    overrides = {
                        disable_frontmatter = true,
                    }
                },
            },
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
        keys = {
            { ",v", "<cmd>VenvSelect<cr>" },
        },
    },

    -- terraform
    { 'hashivim/vim-terraform' },
    { 'juliosueiras/vim-terraform-completion' },
}
