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

------------------------------------------------
--------------- General settings ---------------
------------------------------------------------
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

-------------------------------------------------
------- settings for different filetypes --------
-------------------------------------------------
-- Autocommands for filetypes
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.hql", "*.ddl" },
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

vim.g.python3_host_prog = vim.env.HOME .. '/.pyenv/versions/nvim/bin/python3'


-----------------------------------------
---------------- keymaps ----------------
-----------------------------------------

-- Window resizing mappings in normal mode
vim.api.nvim_set_keymap('n', '+', '<C-w>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-', '<C-w>-', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '|', '<C-w>|', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '_', '<C-w>_', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '=', '<C-w>=', { noremap = true, silent = true })

-- Visual mode reselection mappings
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })

-- jqf
vim.cmd("command! Jqf %!jq '.'")

-- Source matchit.vim
vim.cmd("source $VIMRUNTIME/macros/matchit.vim")

-- format
vim.api.nvim_create_user_command('Format', function()
    vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
end, {})

-----------------------------------------
----------------- other -----------------
-----------------------------------------

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

require("lazy_nvim").setup(require("plugins"))

-- copilotChat
local file = io.open(vim.env.HOME .. '/.config/github-copilot/apps.json', "r")
if file then
    file:close()
    require("CopilotChat").setup {
        debug = true, -- Enable debugging
        -- See Configuration section for rest
    }
end

-- Enable syntax highlighting
vim.cmd [[syntax enable]]
