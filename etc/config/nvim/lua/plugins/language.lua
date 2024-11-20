-- vim-markdown settings
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_conceal = 0
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
    { 'kannokanno/previm' },
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
    },

    -- python
    { 'psf/black',                            branch = 'stable' },
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
