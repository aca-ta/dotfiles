return {

    { 'tpope/vim-repeat' },
    { 'tpope/vim-speeddating' },
    { 'AndrewRadev/linediff.vim' },
    { 'rickhowe/diffchar.vim' },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },

}