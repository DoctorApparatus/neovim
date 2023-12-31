return {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        {
            'j-hui/fidget.nvim',
            tag = 'legacy',
            opts = {}
        },
        -- Additional lua configuration, makes nvim stuff amazing!
        'folke/neodev.nvim',

        'DoctorApparatus/nvim-base16',
    },
    opts = {
        inlay_hints = {
            enabled = true,
        },
    },
    config = function()
        require('mason').setup()
        require('neodev').setup()
        require("mason-lspconfig").setup {
            ensure_installed = { "lua_ls", },
        }
        local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol
            .make_client_capabilities())

        -- INFO: LSP Server
        require('lspconfig')['bashls'].setup {
            capabilities = capabilities,
        }
        require('lspconfig')['html'].setup {
            capabilities = capabilities,
        }
        require('lspconfig')['lua_ls'].setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    workspace = {
                        checkThirdParty = "Disable",
                    },
                }
            }

        })
        require('lspconfig')['openscad_lsp'].setup {
            capabilities = capabilities,
        }

        -- INFO: Rust anaylzer is added via rust-tools
        -- require('lspconfig').setup {
        --     settings = {
        --         ["rust-analyzer"] = {
        --             checkOnSave = {
        --                 command = "clippy",
        --             },
        --         }
        --     }
        -- }

        require('lspconfig')['tailwindcss'].setup {
            capabilities = capabilities,
        }
        require('lspconfig')['tsserver'].setup {
            capabilities = capabilities,
            cmd = {
                "typescript-language-server", "--stdio"
            },
            flags = {
                debounce_text_changes = 150,
            },
        }

        -- INFO: Diagnostics
        vim.diagnostic.config({
            underline = true,
            update_in_insert = false,
            virtual_text = {
                spacing = 4,
                source = "if_many",
                prefix = "●",
                -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
                -- prefix = "icons",
            },
            severity_sort = true,
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                vim.keymap.set('n', '<space>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                -- INFO: Replaced by code-action-menu
                -- vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<space>f', function()
                    vim.lsp.buf.format { async = true }
                end, opts)
            end,
        })
    end
}
