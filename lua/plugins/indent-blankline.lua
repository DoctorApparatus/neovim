return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
        enabled = true,
        debounce = 200,
        viewport_buffer = {
            min = 30,
            max = 500,
        },
        indent = {
            char = "▎",
            tab_char = nil,
            highlight = "IblIndent",
            smart_indent_cap = true,
            priority = 1,
        },
        whitespace = {
            highlight = "IblWhitespace",
            remove_blankline_trail = true,
        },
        scope = {
            enabled = false,
            char = nil,
            show_start = true,
            show_end = true,
            show_exact_scope = false,
            injected_languages = true,
            highlight = "IblScope",
            priority = 1024,
            include = {
                node_type = {},
            },
            exclude = {
                language = {},
                node_type = {
                    ["*"] = {
                        "source_file",
                        "program",
                    },
                    lua = {
                        "chunk",
                    },
                    python = {
                        "module",
                    },
                },
            },
        },
        exclude = {
            filetypes = {
                "lspinfo",
                "packer",
                "checkhealth",
                "help",
                "man",
                "gitcommit",
                "TelescopePrompt",
                "TelescopeResults",
                "dashboard",
                "",
            },
            buftypes = {
                "terminal",
                "nofile",
                "quickfix",
                "prompt",
            },
        },
    }
}
