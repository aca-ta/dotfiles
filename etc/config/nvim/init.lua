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
vim.cmd[[syntax enable]]

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
vim.opt.clipboard:append{"unnamedplus"}
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
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = {"*.hql", "*.ddl", "*.js", "*.ts", "*.jsx", "*.tsx", "*.vue", "*.cpp", "*.hpp"},
    command = "setlocal filetype=hive expandtab tabstop=2 shiftwidth=2"
})
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = {"*.py", "*.cpp", "*.sh"},
    command = "0r $HOME/.vim/template/template." .. vim.fn.expand("%:e")
})
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*Jenkinsfile*",
    command = "setf groovy"
})
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*qgs",
    command = "setf xml"
})
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*plb",
    command = "setf sql"
})
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*plb",
    command = "setf sql"
})
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "Dockerfile.*",
    command = "setf Dockerfile"
})
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = {"*.yaml.liquid", "*.yml.liquid"},
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

        { 'nvim-tree/nvim-tree.lua',
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

        { 'Shougo/vimproc.vim', build = 'make' },
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
        { 'psf/black', branch = 'stable' },
        { 'AndrewRadev/linediff.vim' },
        { 'rickhowe/diffchar.vim' },
        { 'glidenote/memolist.vim' },
        { 'rhysd/vim-clang-format' },
        { 'justmao945/vim-clang' },
        { 'tell-k/vim-autopep8' },

        { 'neoclide/coc.nvim', branch = 'release' },
        { 'gelguy/wilder.nvim',
          build = function()
              vim.fn['UpdateRemotePlugins']()
          end,
          config = function()
              local wilder = require('wilder')
              wilder.setup({modes = {':', '/', '?'}})
              wilder.set_option({
                  renderer = wilder.popupmenu_renderer(
                  {
                      pumblend =  20,
                      highlighter =  wilder.basic_highlighter()
                  })
              })
          end
    },
        { 'mzlogin/vim-markdown-toc' },
        { 'tpope/vim-rhubarb' },
        { 'rhysd/conflict-marker.vim' },
        { 'github/copilot.vim' },
        { 'iamcco/markdown-preview.nvim', build = 'cd app && npx --yes yarn install' },
        { 'zbirenbaum/copilot.lua' },
        { 'nvim-lua/plenary.nvim' },
        { 'CopilotC-Nvim/CopilotChat.nvim', branch = 'canary' },

        { 'akinsho/toggleterm.nvim', version = "*", config = function() require('toggleterm').setup() end},
        { 'EdenEast/nightfox.nvim', config = function() vim.cmd('colorscheme nightfox') end },
        { 'lukas-reineke/indent-blankline.nvim',
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
                require("which-key").register({
                    e = {'<cmd>NvimTreeToggle<CR>', 'nvim tree toggle'},
                    f = { "<cmd>Telescope find_files<cr>", "Telescple Find File" },
                    g = { "<cmd>Telescope live_grep<cr>", "Telescple live grep" },
                },{ prefix = "<leader>" })
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
            'nvim-telescope/telescope.nvim', tag = '0.1.6',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        { 'petertriho/nvim-scrollbar', config = function() require("scrollbar").setup() end},
        {
          'pwntester/octo.nvim',
          dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
          },
          config = function ()
            require('octo').setup()
          end
        }
})

-- Window resizing mappings in normal mode
vim.api.nvim_set_keymap('n', '+', '<C-w>+', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '-', '<C-w>-', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '|', '<C-w>|', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '_', '<C-w>_', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '=', '<C-w>=', {noremap = true, silent = true})

-- Visual mode reselection mappings
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true, silent = true})

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

-- coc.nvim
vim.api.nvim_set_keymap("n", "gr", "<Plug>(coc-references)", { noremap = true })
vim.api.nvim_set_keymap("n", "rn", "<Plug>(coc-rename)", { noremap = true })
-- インサートモードで <C-x><C-o> を押した時に coc#refresh() を実行する
vim.api.nvim_set_keymap('i', '<C-x><C-o>', 'coc#refresh()', { noremap = true, silent = true, expr = true })
--
-- CocSplitIfNotOpen function equivalent in Lua
local function CocSplitIfNotOpen(args)
    local cursorCmd = ''
    local fname = args[1]
    if #args == 2 then  -- Two arguments.
        cursorCmd = args[1]
        fname = args[2]
    end
    -- Check if the current file is not the target file
    if fname ~= vim.fn.fnamemodify(vim.fn.expand('%'), ':p:~:.') then
        vim.cmd('vsplit ' .. fname)
    end
    -- Execute cursor command if exists
    if cursorCmd and #cursorCmd > 0 then
        vim.cmd(cursorCmd)
    end
end
vim.api.nvim_set_keymap("n", "tj", ": call CocAction('jumpDefinition')<CR>", { noremap = true })

local function show_documentation()
    local filetype = vim.bo.filetype  -- 現在のバッファの filetype を取得
    if filetype == 'vim' or filetype == 'help' then
        -- ヘルプドキュメントを検索して開く
        local word = vim.fn.expand('<cword>')  -- カーソル下の単語を取得
        vim.cmd('help ' .. word)
    else
        -- CoC の doHover アクションを実行
        vim.fn.CocAction('doHover')
    end
end
vim.api.nvim_set_keymap('n', 'gd', '', {
    noremap = true,
    silent = true,
    callback = show_documentation
})

-- Define the CocJumpCmd command in Lua
vim.api.nvim_create_user_command('CocJumpCmd', function(opts)
    CocSplitIfNotOpen(vim.split(opts.args, " "))
end, { nargs = '+' })

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
vim.api.nvim_create_autocmd({"InsertEnter", "CmdlineEnter"}, {
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
