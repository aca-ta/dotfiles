return {
    { 'tyru/open-browser.vim' },
    { 'glidenote/memolist.vim' },
    { 'github/copilot.vim' },
    { 'zbirenbaum/copilot.lua' },
    { 'CopilotC-Nvim/CopilotChat.nvim' },

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
                        highlighter = { wilder.basic_highlighter(), wilder.lua_pcre2_highlighter() },
                        highlights = {
                            accent = wilder.make_hl('WilderAccent', 'Pmenu',
                                { { a = 1 }, { a = 1 }, { foreground = '#f4468f' } }),
                        },
                    }
                )
            })
            wilder.set_option('pipeline', {
                wilder.branch(
                    wilder.cmdline_pipeline({
                        -- sets the language to use, 'vim' and 'python' are supported
                        language = 'python',
                        -- 0 turns off fuzzy matching
                        -- 1 turns on fuzzy matching
                        -- 2 partial fuzzy matching (match does not have to begin with the same first letter)
                        fuzzy = 1,
                    }),
                    wilder.python_search_pipeline({
                        -- can be set to wilder#python_fuzzy_delimiter_pattern() for stricter fuzzy matching
                        pattern = wilder.python_fuzzy_pattern(),
                        -- omit to get results in the order they appear in the buffer
                        sorter = wilder.python_difflib_sorter(),
                        -- can be set to 're2' for performance, requires pyre2 to be installed
                        -- see :h wilder#python_search() for more details
                        engine = 're',
                    })
                ),
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
