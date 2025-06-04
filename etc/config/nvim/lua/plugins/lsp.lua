local manson_nvim =
{
    "williamboman/mason.nvim", -- LSP Installer
    dependencies = {
        { "williamboman/mason-lspconfig.nvim" },
        "neovim/nvim-lspconfig",
        "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    config = function()
        require "mason".setup {}

        local mason_lspconfig = require("mason-lspconfig")
        local lspconfig = require("lspconfig")
        mason_lspconfig.setup({
            ensure_installed = { "lua_ls", "pyright", "terraformls", "ts_ls", "gopls", "bashls", "rust_analyzer", "yamlls", "clangd" },
            automatic_installation = true,
        })
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        vim.keymap.set("n", "tj", vim.lsp.buf.definition, { buffer = bufnr })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })

        lspconfig.gopls.setup({
            capabilities = capabilities,
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                },
            }
        })

        lspconfig.bashls.setup({
            capabilities = capabilities,
            filetypes = { "sh", "bash" }
        })

        lspconfig.ts_ls.setup({
            capabilities = capabilities,
            filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" },
            init_options = {
                plugins = {
                    {
                        name = "@vue/typescript-plugin",
                        location = require("mason-registry").get_package("vue-language-server"),
                        languages = { "javascript", "typescript", "vue" },
                    },
                },
            },
        })

        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }, -- vimをグローバル変数として認識
                    },
                },
            },
        })
        vim.cmd("LspStart")
    end,
}

-- diagnosticを常にfloatingで表示
vim.diagnostic.config({
    virtual_text = false,     -- 仮想テキストを無効化
    signs = true,             -- サインカラムは表示（必要に応じて切り替え）
    underline = true,         -- エラー部分に下線を表示
    update_in_insert = false, -- インサートモードでは更新しない（オプション）
    severity_sort = true,     -- 深刻度でソート
    float = {
        source = "always",    -- エラーのソースを常に表示
        format = function(diagnostic)
            return string.format("%s (%s)", diagnostic.message, diagnostic.source)
        end,
        header = "", -- ヘッダーを空にする
        prefix = "", -- プレフィックスを空にする
    },
})

-- カーソルが止まったときにdiagnosticを表示
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
    end
})

-- カーソルが移動した際も更新する場合は以下を追加
vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
    end
})

local lsp_signature = {
    "ray-x/lsp_signature.nvim",
    opts = {
        bind = true,
        handler_opts = {
            border = "rounded"
        }
    },
    config = function(_, opts) require 'lsp_signature'.setup(opts) end
}

local fidget = {
    "j-hui/fidget.nvim",
    event = 'BufEnter',
    config = function()
        require "fidget".setup()
    end
}


local nvim_cmp_lazy =
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
}

local nvim_lspsaga =
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
            lightbulb = {
                enable = false,
                enable_in_insert = false,
                sign = false,
                sign_priority = 40,
                virtual_text = false,
            },
            rename = {
                in_select = false
            }
        })

        -- キーマッピングの設定
        local keymap = vim.keymap.set
        keymap("n", "gr", "<cmd>:Lspsaga finder<CR>")
        keymap("n", "gi", "<cmd>Lspsaga incoming_calls<CR>")
        keymap("n", "go", "<cmd>Lspsaga outgoing_calls<CR>")
        keymap("n", "rn", "<cmd>Lspsaga rename<CR>")
        keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>")
        keymap("n", "<leader>r", "<cmd>Lspsaga show_workspace_diagnostics<CR>")
        keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { buffer = true })
        keymap("v", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { buffer = true })
    end,
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
        { "nvim-treesitter/nvim-treesitter" }
    }
}

local none_ls =
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
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.black
            },
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            -- 言語ごとにautoformatするかどうかを決める
                            local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
                            if filetype == 'terraform' or filetype == "lua" then
                                vim.lsp.buf.format({ async = false })
                            end
                        end,
                    })
                end
            end,
        })
    end
}

return {
    manson_nvim,
    nvim_cmp_lazy,
    nvim_lspsaga,
    none_ls,
    lsp_signature,
    fidget
}
