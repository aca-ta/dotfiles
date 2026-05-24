-- vim-test
vim.g["test#strategy"] = "neovim"
vim.g["test#python#runner"] = 'pyunit'
vim.g["test#vim#term_position"] = "aboveleft"
vim.g["test#python#pytest#options"] = '-vv'
vim.g["test#javascript#runner"] = 'jest'

-- avante
-- vim.opt.laststatus = 3

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
                direction = 'float',
                size = function(term)
                    if term.direction == "horizontal" then
                        return vim.o.lines * 0.35
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.35
                    end
                end
            })
            vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
                callback = function()
                    if vim.bo.buftype == "terminal" then
                        vim.schedule(function()
                            vim.cmd("startinsert")
                        end)
                    end
                end,
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
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        config = true,
        lazy = false,
        opts = {
            diff_opts = {
                keep_terminal_focus = true, -- trueにすると、diff開いた後もClaudeウィンドウにフォーカスが戻る
            },
        },
        keys = {
            { "<leader>a",  nil,                              desc = "AI/Claude Code" },
            { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
            { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
            { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                 desc = "Send to Claude" },
            {
                "<leader>as",
                "<cmd>ClaudeCodeTreeAdd<cr>",
                desc = "Add file",
                ft = { "NvimTree", "neo-tree", "oil" },
            },
            -- Diff management
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
        },
    },
    {
        "ishiooon/codex.nvim",
        dependencies = { "folke/snacks.nvim" },
        opts = {
            status_indicator = { enabled = false },
        },
        keys = {
            { "<leader>cc", "<cmd>Codex<cr>", desc = "Codex: Toggle" },
            { "<leader>cf", "<cmd>CodexFocus<cr>", desc = "Codex: Focus" },
            { "<leader>cs", "<cmd>CodexSend<cr>", mode = "v", desc = "Codex: 選択範囲を送信" },
            {
                "<leader>cs",
                "<cmd>CodexTreeAdd<cr>",
                desc = "Codex: ファイルを追加",
                ft = { "neo-tree", "oil" },
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
                vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
                vim.fn.sign_define('DapStopped', {
                    text = '➡️', -- 現在位置を示す矢印のシンボル
                    texthl = 'DapStopped', -- カスタムハイライトグループ名（下で定義）
                    linehl = 'CursorLine', -- 行全体にハイライトを付ける場合
                    numhl = ''
                })

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
                        program = function()
                            -- ユーザーにファイルパスを入力させるプロンプトを表示
                            return vim.fn.input('Path to Python file: ', vim.fn.getcwd() .. '/', 'file')
                        end,
                        env = { PYTHONPATH = vim.fn.getcwd() },
                    },
                    {
                        type = "python",
                        request = "launch",
                        name = "Run command",
                        module = function()
                            -- モジュール名の入力を求める
                            local module_name = vim.fn.input('Module name (e.g. pytest): ', 'pytest')
                            return module_name
                        end,
                        args = function()
                            -- コマンドの引数を求める
                            return vim.split(vim.fn.input('Arguments: ', '', 'file'), " ")
                        end,
                        env = { PYTHONPATH = vim.fn.getcwd() },
                        cwd = "${workspaceFolder}",
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
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                end

                vim.api.nvim_create_user_command("DapUIToggle", function() dapui.toggle() end, { desc = "Toggle DAP UI" })
            end,
        },
        {
            "Weissle/persistent-breakpoints.nvim",
            dependencies = { "mfussenegger/nvim-dap" },
            config = function()
                require('persistent-breakpoints').setup {
                    save_dir = vim.fn.stdpath('data') .. '/nvim_checkpoints',
                    -- when to load the breakpoints? "BufReadPost" is recommanded.
                    load_breakpoints_event = nil,
                    -- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
                    perf_record = false,
                    -- perform callback when loading a persisted breakpoint
                    --- @param opts DAPBreakpointOptions options used to create the breakpoint ({condition, logMessage, hitCondition})
                    --- @param buf_id integer the buffer the breakpoint was set on
                    --- @param line integer the line the breakpoint was set on
                    on_load_breakpoint = nil,
                    -- set this to true if the breakpoints are not loaded when you are using a session-like plugin.
                    always_reload = true,
                }

                -- Auto-load breakpoints on Neovim startup
                vim.api.nvim_create_autocmd("VimEnter", {
                    callback = function()
                        vim.cmd("PBLoad")
                    end,
                    desc = "Auto-load persistent breakpoints on Neovim startup"
                })
            end
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
                    open = function(files, argv, stdin_buf, guest_cwd)
                        -- ターミナル以外のウィンドウを探す
                        local target_win = nil
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            if vim.bo[buf].buftype ~= "terminal" then
                                target_win = win
                                break
                            end
                        end
                        if target_win then
                            vim.api.nvim_set_current_win(target_win)
                            vim.cmd("vsplit")
                        else
                            vim.cmd("vsplit")
                        end
                    end
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
