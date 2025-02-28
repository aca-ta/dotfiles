-- GitGutter
vim.g.gitgutter_highlight_lines = 0
vim.g.gitgutter_max_signs = 1000
vim.api.nvim_set_keymap("n", "gn", ":GitGutterNextHunk<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "gp", ":GitGutterPrevHunk<CR>", { noremap = true })


return {

    { 'airblade/vim-gitgutter' },
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-rhubarb' }, -- furgitive extension
}
