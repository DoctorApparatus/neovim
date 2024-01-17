return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("obsidian").setup({
			workspace = {
				name = "Vault",
				path = "~/Vault",
			},
			templates = {
				subdir = "Configs/Templates",
			},
		})
	end,
}
