return {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "lua" },
			sync_install = true,
			auto_install = true,
			highlight = {
				enable = true,
			},
			modules = {},
			ignore_install = {},
			incremental_selection = {
				enable = true,
				keymaps = {
					-- init_selection = "<leader>v", -- set to `false` to disable one of the mappings
					-- node_incremental = "v",
					-- scope_incremental = "V",
					-- node_decremental = "grm",
				},
			},
		})
	end,
}
