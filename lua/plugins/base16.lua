return {
	-- 'DoctorApparatus/nvim-base16',
	dir = "/home/doctorapparatus/Repos/nvim-base16/",
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
		vim.cmd([[colorscheme base16-gruvbox-material-dark-medium]])
	end,
}
