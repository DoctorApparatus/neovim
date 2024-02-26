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
			workspaces = {
				{
					name = "Vault",
					path = os.getenv("HOME") .. "/Notes/Vault",
				},
				{
					name = "Notes",
					path = os.getenv("HOME") .. "/Notes/",
				},
			},
		})
	end,
}
