return {
    "folke/drop.nvim",
    event = "VimEnter",
    config = function()
        require("drop").setup({
            theme = "snow",              -- can be one of rhe default themes, or a custom theme
            max = 40,                    -- maximum number of drops on the screen
            interval = 150,              -- every 150ms we update the drops
            screensaver = 1000 * 60 * 5, -- show after 5 minutes. Set to false, to disable
            filetypes = { "starter" },   -- will enable/disable automatically for the following filetypes
        })
    end,
}
