local manson_nvim =
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

        -- python-lspの関連ライブラリのインストール
        local pylsp = require("mason-registry").get_package("python-lsp-server")
        pylsp:on("install:success", function()
            local path = vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. "python-lsp-server")
            local command = path .. "/venv/bin/pip"
            local args = {
                "install",
                "pylsp-rope",
                "python-lsp-ruff",
                "sqlalchemy-stubs",
            }

            require("plenary.job")
                :new({
                    command = command,
                    args = args,
                    cwd = path,
                })
                :start()
        end)

        local mason_lspconfig = require("mason-lspconfig")
        local lspconfig = require("lspconfig")
        mason_lspconfig.setup({
            ensure_installed = { "lua_ls", "pylsp", "terraformls", "ts_ls", "gopls", "bashls", "volar" },
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
                elseif server_name == "ts_ls" then
                    local vue_typescript_plugin = require("mason-registry").get_package("vue-language-server")
                        :get_install_path() .. "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin"
                    opts.init_options = {
                        plugins = {
                            {
                                name = "@vue/typescript-plugin",
                                location = vue_typescript_plugin,
                                languages = { "javascript", "typescript", "vue" },
                            },
                        },
                    }
                    opts.filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact",
                        "typescript.tsx", "vue" }
                elseif server_name == "lua_ls" then
                    opts.settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" }
                            }
                        }
                    }
                end

                lspconfig[server_name].setup(opts)
            end
        })
        vim.cmd("LspStart")
    end,
}

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
        keymap("n", "<leader>a", "<cmd>Lspsaga code_action<CR>", { buffer = true })
        keymap("v", "<leader>a", "<cmd>Lspsaga code_action<CR>", { buffer = true })
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
