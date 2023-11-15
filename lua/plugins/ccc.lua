return {
    "uga-rosa/ccc.nvim",
    config = function()
        require('ccc').setup({
            -- Your preferred settings
            -- Example: enable highlighter
            highlighter = {
                auto_enable = true,
                lsp = true,
            },
        })
    end
}
