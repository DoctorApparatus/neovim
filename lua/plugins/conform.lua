return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				javascript = { "biome" },
				typescript = { "biome" },
				javascriptreact = { "biome" },
				typescriptreact = { "biome" },
				svelte = { "biome" },
				css = { "biome" },
				html = { "biome" },
				json = { "biome" },
				yaml = { "biome" },
				-- markdown = { "biome" },
				graphql = { "biome" },
				lua = { "stylua" },
				rust = { "rustfmt" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			},
		})
	end,
}
