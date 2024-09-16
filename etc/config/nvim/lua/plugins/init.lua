-- copilotChat
local file = io.open(vim.env.HOME .. '/.config/github-copilot/apps.json', "r")
if file then
    file:close()
    require("CopilotChat").setup {
        debug = true, -- Enable debugging
        -- See Configuration section for rest
    }
end

return {
    { 'tyru/open-browser.vim' },
    { 'glidenote/memolist.vim' },
    { 'github/copilot.vim' },
    { 'zbirenbaum/copilot.lua' },
    { 'CopilotC-Nvim/CopilotChat.nvim', branch = 'canary' },

    {
        'gelguy/wilder.nvim',
        build = function()
            vim.fn['UpdateRemotePlugins']()
        end,
        config = function()
            local wilder = require('wilder')
            wilder.setup({ modes = { ':', '/', '?' } })
            wilder.set_option({
                renderer = wilder.popupmenu_renderer(
                    {
                        pumblend = 20,
                        highlighter = wilder.basic_highlighter()
                    })
            })
        end
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        config = function()
            require("which-key").add({
                { "<leader>e", "<cmd>NvimTreeToggle<CR>",       desc = "nvim tree toggle" },
                { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Telescple Find File" },
                { "<leader>g", "<cmd>Telescope live_grep<cr>",  desc = "Telescple live grep" },
                { "<leader>t", "<cmd>ToggleTerm<cr>",           desc = "ToggleTerm" },
                { "<leader>c", "<cmd>CopilotChatOpen<cr>",      desc = "CopilotChat" },
            }, { prefix = "<leader>" })
        end
    },
    require("plugins.lsp"),
    require("plugins.ui"),
    require("plugins.git"),
    require("plugins.ide"),
    require("plugins.language"),
    require("plugins.text"),
}
