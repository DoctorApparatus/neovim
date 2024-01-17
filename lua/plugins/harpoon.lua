return {
	"ThePrimeagen/harpoon",
	config = function()
		require("harpoon").setup({})
		require("telescope").load_extension("harpoon")

		local wk = require("which-key")
		wk.register({
			["<leader>ha"] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "open code action menu" },
			["<leader>hf"] = { "<cmd>Telescope harpoon marks<cr>", "open code action menu" },
		})
	end,
}
