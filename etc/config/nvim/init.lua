-- Check for additional vimrc and source it if exists
local additional_vimrc = vim.fn.expand("$HOME") .. "/.vim/additional_vimrc"
if vim.fn.filereadable(additional_vimrc) == 1 then
    vim.cmd("source " .. additional_vimrc)
end
-- nvim-tree.lua
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

-- Enable syntax highlighting
vim.cmd [[syntax enable]]

-- General settings
vim.opt.termguicolors = true
vim.opt.updatetime = 1
vim.opt.visualbell = true
vim.opt.mouse = "a"

vim.opt.number = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.showtabline = 4
vim.opt.tabstop = 4
vim.opt.list = true
vim.opt.listchars = { tab = "| " }
vim.opt.ic = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.clipboard:append { "unnamedplus" }
vim.opt.showmatch = true
vim.opt.backspace = "eol,indent,start"
vim.opt.laststatus = 2
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.encoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "utf-8,iso-2022-jp,cp932,sjis,euc-jp"

vim.opt.splitright = true
vim.opt.switchbuf:append({ "usetab", "newtab" })

-- Autocommands for filetypes
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.hql", "*.ddl", "*.js", "*.ts", "*.jsx", "*.tsx", "*.vue", "*.cpp", "*.hpp" },
    command = "setlocal filetype=hive expandtab tabstop=2 shiftwidth=2"
})
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = { "*.py", "*.cpp", "*.sh" },
    command = "0r $HOME/.vim/template/template." .. vim.fn.expand("%:e")
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*Jenkinsfile*",
    command = "setf groovy"
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*qgs",
    command = "setf xml"
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*plb",
    command = "setf sql"
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*plb",
    command = "setf sql"
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "Dockerfile.*",
    command = "setf Dockerfile"
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.yaml.liquid", "*.yml.liquid" },
    command = "setf yaml"
})

-- Source matchit.vim
vim.cmd("source $VIMRUNTIME/macros/matchit.vim")

vim.g.python3_host_prog = vim.env.HOME .. '/.pyenv/shims/python3'

-- Vim-Plug setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
-- vim.cmd("lang en_US.UTF-8")

require("lazy").setup({
    { 'autowitch/hive.vim' },

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

    { 'gorodinskiy/vim-coloresque' },
    { 'yuttie/hydrangea-vim' },
    { 'tpope/vim-vividchalk' },
    { 'liuchengxu/space-vim-dark' },

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
    { 'tpope/vim-repeat' },
    { 'tpope/vim-speeddating' },
    { 'mechatroner/rainbow_csv' },
    { 'tpope/vim-fugitive' },
    { 'godlygeek/tabular' },
    { 'plasticboy/vim-markdown' },
    { 'airblade/vim-gitgutter' },

    { 'Shougo/vimproc.vim',                   build = 'make' },
    { 'tpope/vim-commentary' },
    { 'thinca/vim-quickrun' },
    -- { 'kana/vim-operator-user' },
    -- { 'kana/vim-operator-replace' },
    { 'kannokanno/previm' },
    { 'tyru/open-browser.vim' },
    { 'janko/vim-test' },

    { 'nathanaelkane/vim-indent-guides' },
    { 'hashivim/vim-terraform' },
    { 'juliosueiras/vim-terraform-completion' },
    { 'luochen1990/rainbow' },
    { 'puremourning/vimspector' },
    { 'psf/black',                            branch = 'stable' },
    { 'AndrewRadev/linediff.vim' },
    { 'rickhowe/diffchar.vim' },
    { 'glidenote/memolist.vim' },
    { 'rhysd/vim-clang-format' },
    { 'justmao945/vim-clang' },
    { 'tell-k/vim-autopep8' },

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
    { 'mzlogin/vim-markdown-toc' },
    { 'tpope/vim-rhubarb' },
    { 'rhysd/conflict-marker.vim' },
    { 'github/copilot.vim' },
    {
        'iamcco/markdown-preview.nvim',
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" }
    },
    { 'zbirenbaum/copilot.lua' },
    { 'nvim-lua/plenary.nvim' },
    { 'CopilotC-Nvim/CopilotChat.nvim', branch = 'canary' },

    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function()
            require('toggleterm').setup()
        end
    },
    { 'EdenEast/nightfox.nvim',   config = function() vim.cmd('colorscheme nightfox') end },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("ibl").setup()
        end
    },
    { 'delphinus/cellwidths.nvim' },
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
            }, { prefix = "<leader>" })
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup()
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { 'petertriho/nvim-scrollbar', config = function() require("scrollbar").setup() end },
    {
        'pwntester/octo.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require('octo').setup()
        end
    },
    {
        "williamboman/mason.nvim", -- LSP Installer
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
        },
        event = "VeryLazy",
        config = function()
            require "mason".setup {}
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")
            mason_lspconfig.setup({
                ensure_installed = { "lua_ls", "pyright", "terraformls", "tsserver", "gopls", "bashls" },
                automatic_installation = true,
            })
            mason_lspconfig.setup_handlers({
                function(server_name)
                    local opts = {
                        capabilities = require('cmp_nvim_lsp').default_capabilities(),
                        on_attach = function(client, bufnr)
                            -- キーマッピング
                            vim.keymap.set("n", "tj", vim.lsp.buf.definition, { buffer = bufnr })
                            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
                            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
                        end,
                    }

                    -- サーバー固有の設定
                    if server_name == "gopls" then
                        opts.settings = {
                            gopls = {
                                analyses = {
                                    unusedparams = true,
                                },
                                staticcheck = true,
                            },
                        }
                    elseif server_name == "bashls" then
                        opts.filetypes = { "sh", "bash" }
                    end

                    lspconfig[server_name].setup(opts)
                end
            })
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }
                        }
                    }
                }
            })
            vim.cmd("LspStart")
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        config = function()
            -- https://github.com/nvimtools/none-ls.nvim/wiki/Formatting-on-save#sync-formatting
            local null_ls = require("null-ls")
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            null_ls.setup({
                -- format on save
                sources = {
                    null_ls.builtins.formatting.terraform_fmt,
                    null_ls.builtins.formatting.stylua
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ async = false })
                            end,
                        })
                    end
                end,
            })
        end
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "neovim/nvim-lspconfig",
        },
        event = "InsertEnter",
        config = function()
            local cmp = require('cmp')
            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                    -- 他のソースを追加
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-x><C-o>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
            })
        end
    },
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        config = function()
            require("lspsaga").setup({
                callhierarchy = {
                    show_detail = true,
                    keys = {
                        edit = "e",
                        vsplit = "s",
                        split = "i",
                        tabe = "t",
                        jump = "o",
                        quit = "q",
                        expand_collapse = "u",
                    },
                },
            })

            -- キーマッピングの設定
            local keymap = vim.keymap.set
            keymap("n", "gr", "<cmd>:Lspsaga finder<CR>")
            keymap("n", "gi", "<cmd>Lspsaga incoming_calls<CR>")
            keymap("n", "go", "<cmd>Lspsaga outgoing_calls<CR>")
            keymap("n", "rn", "<cmd>Lspsaga rename<CR>")
            keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>")
        end,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            { "nvim-treesitter/nvim-treesitter" }
        }
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    }
})

-- Window resizing mappings in normal mode
vim.api.nvim_set_keymap('n', '+', '<C-w>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-', '<C-w>-', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '|', '<C-w>|', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '_', '<C-w>_', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '=', '<C-w>=', { noremap = true, silent = true })

-- Visual mode reselection mappings
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })

-- NERDTree
vim.g.NERDTreeShowHidden = 1
vim.g.nerdtree_tabs_open_on_gui_startup = 0

-- GitGutter
vim.g.gitgutter_highlight_lines = 0
vim.g.gitgutter_max_signs = 1000
vim.api.nvim_set_keymap("n", "gn", ":GitGutterNextHunk<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "gp", ":GitGutterPrevHunk<CR>", { noremap = true })

-- vim-markdown settings
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_markdown_new_list_item_indent = 0

-- vim-markdown-toc settings
vim.g.vmt_fence_text = 'TOC START'
vim.g.vmt_fence_closing_text = 'TOC END'


-- Set up other plugin configurations and mappings similarly
-- vim-test
vim.g["test#strategy"] = "neovim"
vim.g["test#python#runner"] = 'pyunit'
vim.g["test#vim#term_position"] = "aboveleft"
vim.g["test#python#pytest#options"] = '-vv'
vim.g["test#javascript#runner"] = 'jest'

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = -1 })
    end
})
-- clear highlight when insert mode.
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
    group = vim.api.nvim_create_augroup("clear_highlight_yank", { clear = true }),
    callback = function()
        vim.api.nvim_command('highlight clear HighlightedyankRegion')
    end
})

-- copilotChat
local file = io.open(vim.env.HOME .. '/.config/github-copilot/apps.json', "r")
if file then
    file:close()
    require("CopilotChat").setup {
        debug = true, -- Enable debugging
        -- See Configuration section for rest
    }
end

-- jqf
vim.cmd("command! Jqf %!jq '.'")
