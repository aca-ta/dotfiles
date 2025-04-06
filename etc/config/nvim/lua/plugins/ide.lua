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
            require('toggleterm').setup({
                direction = 'float'
            })
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- { 'puremourning/vimspector' },
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
            provider = "copilot",
            auto_suggestions_provider = "copilot",
            -- openai = {
            --     model = "gpt-4o", -- $2.5/$10
            --     -- model = "gpt-4o-mini", -- $0.15/$0.60
            --     max_tokens = 4096,
            -- },
            copilot = {
                endpoint = "https://api.githubcopilot.com",
                model = "claude-3.7-sonnet", -- ここでClaudeモデルを指定
                timeout = 30000,
                temperature = 0,
                max_tokens = 4096,
            },
            behaviour = {
                auto_suggestions = true,
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = true,
                support_paste_from_clipboard = true,
                cursor_planning_mode = true,
            },
            windows = {
                position = "right",
                width = 30,
                sidebar_header = {
                    align = "center",
                    rounded = false,
                },
                ask = {
                    start_insert = true,
                    border = "rounded"
                }
            },

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
    },
    {
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
        },
        -- comment the following line to ensure hub will be ready at the earliest
        cmd = "MCPHub",                          -- lazy load by default
        build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
        -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
        -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
        config = function()
            require("mcphub").setup()
        end,
    },
    {
        {
            "mfussenegger/nvim-dap",
            config = function()
                local dap = require("dap")

                -- 例: Python のデバッガ設定
                dap.adapters.python = {
                    type = "executable",
                    command = "python",
                    args = { "-m", "debugpy.adapter" },
                }

                dap.configurations.python = {
                    {
                        type = "python",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                    },
                }
            end,
        },
        {
            "rcarriga/nvim-dap-ui",
            dependencies = { "mfussenegger/nvim-dap", 'nvim-neotest/nvim-nio', { "theHamsta/nvim-dap-virtual-text", opts = {} } },
            config = function()
                local dap, dapui = require("dap"), require("dapui")
                dapui.setup()

                -- DAP イベントに応じて UI を開閉
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open()
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close()
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close()
                end
            end,
        },
        {
            "amitds1997/remote-nvim.nvim",
            version = "*",                       -- Pin to GitHub releases
            dependencies = {
                "nvim-lua/plenary.nvim",         -- For standard functions
                "MunifTanjim/nui.nvim",          -- To build the plugin UI
                "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
            },
            config = true,
        },
        {
            "willothy/flatten.nvim",
            config = {
                window = {
                    open = "tab"
                }
            },
            -- or pass configuration with
            -- opts = {  }
            -- Ensure that it runs first to minimize delay when opening file from terminal
            lazy = false,
            priority = 1001,
        },
    }
}
