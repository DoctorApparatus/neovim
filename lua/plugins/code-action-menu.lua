return {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
    config = function()
        local wk = require('which-key')
        wk.register({
            ["<leader>ca"] = { "<cmd>CodeActionMenu<cr>", "open code action menu" },
        })
    end
}
