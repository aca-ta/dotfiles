-- vim-test
vim.g["test#strategy"] = "neovim"
vim.g["test#python#runner"] = 'pyunit'
vim.g["test#vim#term_position"] = "aboveleft"
vim.g["test#python#pytest#options"] = '-vv'
vim.g["test#javascript#runner"] = 'jest'

-- avante
vim.opt.laststatus = 3

return {
    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require("nvim-tree").setup({
                filters = {
                    git_ignored = false,
                },
            })
        end
    },
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function()
            require('toggleterm').setup()
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { 'puremourning/vimspector' },
    { 'janko/vim-test' },
    {
        'thinca/vim-quickrun',
        dependencies = { 'Shougo/vimproc.vim', build = 'make' },
    },
    { 'tpope/vim-commentary' },
    {
        'nacro90/numb.nvim',
        config = function()
            require('numb').setup()
        end,
    },
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
        opts = {
            provider = "copilot"
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "echasnovski/mini.pick",         -- for file_selector provider mini.pick
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
            "ibhagwan/fzf-lua",              -- for file_selector provider fzf
            "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua",        -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    }
}
