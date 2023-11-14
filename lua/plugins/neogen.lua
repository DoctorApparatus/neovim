return {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
        require('neogen').setup({})

        local wk = require('which-key')
        wk.register({
            ["<leader>gc"] = { "<cmd>Neogen<cr>", "generate documentation comment" },
        })
    end,
    version = "*"
}
