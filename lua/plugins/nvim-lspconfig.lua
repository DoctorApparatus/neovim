return {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        -- Useful status updates for LSP
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

        -- Additional lua configuration, makes nvim stuff amazing!
        'folke/neodev.nvim',
        'RRethy/nvim-base16',
    },
    config = function()
        require('mason').setup()
        require('neodev').setup()
        require("mason-lspconfig").setup {
            ensure_installed = { "lua_ls", },
        }
        local on_attach = function(client, bufnr)
        end
        local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol
            .make_client_capabilities())

        require('lspconfig')['lua_ls'].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
        require('lspconfig')['rust_analyzer'].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
    end
}
