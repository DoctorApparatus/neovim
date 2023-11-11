local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

local plugins_full = {
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require('config.neotree.main').setup()
        end
    },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require('bufferline').setup()
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        config = function()
            require('lualine').setup({})
        end
    },
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require('config.whichkey.main').setup()
        end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'onsails/lspkind.nvim',
            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local mapping = {
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                ["<C-e>"] = cmp.mapping {
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                },
                ["<CR>"] = cmp.mapping.confirm { selected = true },
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expandable() then
                        luasnip.expand()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                        -- elseif check_backspace() then
                        --     fallback()
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                        -- elseif luasnip.jumpable(-1) then
                        --    luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, {
                    "i",
                    "s",
                }),
            }
            local window = {
                completion = {
                    col_offset = -3,
                    side_padding = 0,
                }
            }
            local formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(
                        entry, vim_item)
                    local strings = vim.split(
                        kind.kind, "%s",
                        { trimempty = true }
                    )
                    kind.kind = " " .. (strings[1] or "") .. " "
                    kind.menu = "    (" .. (strings[2] or "") .. ")"

                    return kind
                end
            }
            local kind_icons = {
                Text = "",
                Method = "",
                Function = "",
                Constructor = "",
                Field = "",
                Variable = "",
                Class = "",
                Interface = "",
                Module = "",
                Property = "",
                Unit = "",
                Value = "",
                Enum = "",
                Keyword = "",
                Snippet = "",
                Color = "",
                File = "",
                Reference = "",
                Folder = "",
                EnumMember = "",
                Constant = "",
                Struct = "",
                Event = "",
                Operator = "",
                TypeParameter = "",
                Copilot = ""
            }

            local luasnip = require('luasnip')
            local snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            }
            local sources = {
                {
                    name = "nvim_lsp",
                    entry_filter = function(entry, ctx)
                        local kind = require("cmp.types").lsp.CompletionItemKind
                            [entry:get_kind()]
                        if kind == "Snippet" and ctx.prev_context.filetype == "java" then
                            return false
                        end
                        if kind == "Text" then
                            return false
                        end
                        return true
                    end,
                },
                { name = "copilot",    group_index = 2 },
                { name = "path" },
                { name = "luasnip" },
                { name = "nvim_lua" },
                { name = "buffer" },
                { name = "calc" },
                { name = "emoji" },
                { name = "treesitter" },
                { name = "crates" },
                { name = "tmux" },
                { name = 'vsnip' },
                { name = 'crates' },
                { name = 'cmp_tabnine' }
            }

            cmp.setup {
                window = window,
                formatting = formatting,
                mapping = mapping,
                snippet = snippet,
                sources = sources,
                confirm_opts = {
                    behvaior = cmp.ConfirmBehavior.Replace,
                    select = false,
                },
                experimental = {
                    ghost_text = false
                },
            }
            require('cmp').setup({})
        end
    },
    {
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
        end
    },
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        config = function()
            require('luasnip').setup()
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { "lua" },
                sync_install = true,
                auto_install = true,
                highlight = {
                    enable = true
                }
            })
        end
    },
    {
        'RRethy/nvim-base16'
    }
}
require('lazy').setup(plugins_full, {})
