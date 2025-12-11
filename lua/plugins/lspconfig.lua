return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "folke/neodev.nvim", opts = {} },
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local nvim_lsp = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")

        local protocol = require("vim.lsp.protocol")

        -- Configure diagnostics
        vim.diagnostic.config({
            virtual_text = {
                prefix = "●",
            },
            update_in_insert = false,
            float = {
                source = "always", -- Or "if_many"
            },
        })

        local on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- format on save
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("Format", { clear = true }),
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end

            -- Debug: Print when LSP attaches
            print(string.format("LSP attached: %s to buffer %d", client.name, bufnr))
        end

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Setup mason-lspconfig with handlers
        mason_lspconfig.setup({
            automatic_installation = true,
            ensure_installed = {
                "cssls",
                "eslint",
                "html",
                "jsonls",
                "pyright",
                "tailwindcss",
                "rust_analyzer",
                "svelte",
                "clangd",
            },
            handlers = {
            function(server)
                nvim_lsp[server].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
            -- ["tsserver"] = function()
            --     nvim_lsp["tsserver"].setup({
            --         on_attach = on_attach,
            --         capabilities = capabilities,
            --     })
            -- end,
            ["cssls"] = function()
                nvim_lsp["cssls"].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
            ["tailwindcss"] = function()
                nvim_lsp["tailwindcss"].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
            ["html"] = function()
                nvim_lsp["html"].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
            ["jsonls"] = function()
                nvim_lsp["jsonls"].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
            ["eslint"] = function()
                nvim_lsp["eslint"].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
            ["pyright"] = function()
                nvim_lsp["pyright"].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
            ["rust_analyzer"] = function()
                nvim_lsp["rust_analyzer"].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = {
                        ["rust-analyzer"] = {
                            imports = {
                                granularity = {
                                    group = "module",
                                },
                                prefix = "self",
                            },
                            cargo = {
                                buildScripts = {
                                    enable = true,
                                },
                                allFeatures = true,
                            },
                            procMacro = {
                                enable = true
                            },
                            rustfmt = {
                                extraArgs = { "+nightly" },
                            },
                        }
                    },
                    -- Ensure cargo is found
                    init_options = {
                        cargo = {
                            allFeatures = true,
                        },
                    },
                })
            end,
            ["svelte"] = function()
                nvim_lsp["svelte"].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = {
                        svelte = {
                            plugin = {
                                html = { completions = { enable = true, emmet = false } },
                                svelte = { completions = { enable = true, emmet = false } },
                                css = { completions = { enable = true, emmet = true } },
                            },
                        },
                    },
                })
            end,
            ["clangd"] = function()
                nvim_lsp["clangd"].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=llvm",
                    },
                    init_options = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        clangdFileStatus = true,
                    },
                })
            end,
            },
        })
    end,
}
