return {
    'simrat39/rust-tools.nvim',
    config = function()
        local rt = require("rust-tools")
        rt.setup({
            tools = { -- rust-tools options

                -- how to execute terminal commands
                -- options right now: termopen / quickfix / toggleterm / vimux
                executor = require("rust-tools.executors").termopen,

                -- callback to execute once rust-analyzer is done initializing the workspace
                -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
                on_initialized = nil,

                -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
                reload_workspace_from_cargo_toml = true,

                -- These apply to the default RustSetInlayHints command
                inlay_hints = {
                    -- automatically set inlay hints (type hints)
                    -- default: true
                    auto = false,

                    -- Only show inlay hints for the current line
                    only_current_line = false,

                    -- whether to show parameter hints with the inlay hints or not
                    -- default: true
                    show_parameter_hints = false,

                    -- prefix for parameter hints
                    -- default: "<-"
                    parameter_hints_prefix = "<- ",

                    -- prefix for all the other hints (type, chaining)
                    -- default: "=>"
                    other_hints_prefix = "=> ",

                    -- whether to align to the length of the longest line in the file
                    max_len_align = false,

                    -- padding from the left if max_len_align is true
                    max_len_align_padding = 1,

                    -- whether to align to the extreme right or not
                    right_align = false,

                    -- padding from the right if right_align is true
                    right_align_padding = 7,

                    -- The color of the hints
                    highlight = "Comment",
                },
            },
            server = {
                on_attach = function(_, bufnr)
                    vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                    vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                    vim.lsp.inlay_hint(0, true)
                end,
            },
        })
    end
}
