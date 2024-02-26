return {
	"sainnhe/gruvbox-material",
	priority = 1000,
	config = function()
		vim.cmd([[set background=dark]])
		vim.cmd([[let g:gruvbox_material_background = 'medium']])
		vim.cmd([[let g:gruvbox_material_foreground = 'original']])
		vim.cmd([[let g:gruvbox_material_better_performance = 1]])
		vim.cmd([[let g:gruvbox_material_float_style = 'hl-Normal']])
		vim.cmd([[let g:gruvbox_material_transparent_background=1]])
		vim.cmd([[colorscheme gruvbox-material]])
	end,
}
