return {


    { 'gorodinskiy/vim-coloresque' },
    { 'liuchengxu/space-vim-dark' },
    { 'mechatroner/rainbow_csv' },
    { 'luochen1990/rainbow' }, -- Parentheses color
    { 'rhysd/conflict-marker.vim' },
    { 'delphinus/cellwidths.nvim' },
    { 'petertriho/nvim-scrollbar', config = function() require("scrollbar").setup() end },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                sections = {
                    lualine_a = {
                        {
                            'filename',
                            file_status = true, -- displays file status (readonly status, modified status)
                            path = 2            -- 0 = just filename, 1 = relative path, 2 = absolute path
                        }
                    }
                }
            })
        end
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("ibl").setup()
        end
    },
    {
        'sunjon/shade.nvim',
        config = function()
            require('shade').setup({
                overlay_opacity = 70,
                opacity_step = 1,
                keys = {
                    toggle = '<Leader>s',
                }
            })
        end

    }
}
