-- vim-test
vim.g["test#strategy"] = "neovim"
vim.g["test#python#runner"] = 'pyunit'
vim.g["test#vim#term_position"] = "aboveleft"
vim.g["test#python#pytest#options"] = '-vv'
vim.g["test#javascript#runner"] = 'jest'


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
    }

}
