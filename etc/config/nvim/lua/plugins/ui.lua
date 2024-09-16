return {


    { 'gorodinskiy/vim-coloresque' },
    { 'liuchengxu/space-vim-dark' },
    { 'mechatroner/rainbow_csv' },
    { 'luochen1990/rainbow' }, -- Parentheses color
    { 'rhysd/conflict-marker.vim' },
    { 'delphinus/cellwidths.nvim' },
    { 'petertriho/nvim-scrollbar', config = function() require("scrollbar").setup() end },
    { 'EdenEast/nightfox.nvim',    config = function() vim.cmd('colorscheme nightfox') end },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup()
        end
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("ibl").setup()
        end
    },
}
