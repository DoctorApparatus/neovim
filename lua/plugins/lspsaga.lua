return {
    'nvimdev/lspsaga.nvim',
    config = function()
        require('lspsaga').setup({
            ui = {
                code_action = ''
            }
        })


        local wk = require('which-key')
        wk.register({
            ["<leader>cr"] = { "<cmd>Lspsaga rename<cr>", "rename" },
        })
    end,
    dependencies = {
        'nvim-treesitter/nvim-treesitter', -- optional
        'nvim-tree/nvim-web-devicons',     -- optional
    }
}
