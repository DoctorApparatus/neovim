return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require('neo-tree').setup()
        local wk = require('which-key')
        wk.register({
            ["<leader>e"] = { "<cmd>NeoTreeShowToggle<cr>", "open file browser" }
        })
    end
}
