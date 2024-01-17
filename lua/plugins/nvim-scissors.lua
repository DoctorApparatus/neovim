return {
	"chrisgrieser/nvim-scissors",
	dependencies = "nvim-telescope/telescope.nvim", -- optional
	opts = {
		snippetDir = os.getenv("HOME") .. "/.config/nvim/snippets/vscode",
	},
}
