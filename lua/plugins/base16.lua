return {
	"RRethy/base16-nvim",
	enabled = true,
	config = function()
		require("base16-colorscheme").with_config({
			telescope = true,
			telescope_borders = true,
			indentblankline = true,
			notify = true,
			ts_rainbow = true,
			cmp = true,
			illuminate = true,
			lsp_semantic = true,
			mini_completion = true,
			neotree = true,
		})
	end,
}
