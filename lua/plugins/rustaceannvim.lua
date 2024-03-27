return {
	"mrcjkb/rustaceanvim",
	version = "^4", -- Recommended
	ft = { "rust" },
	-- config = function()
	-- 	vim.g.rustaceanvim = {
	-- 		inlay_hints = {
	-- 			highlight = "NonText",
	-- 		},
	-- 		tools = {
	-- 			hover_actions = {
	-- 				auto_focus = true,
	-- 			},
	-- 		},
	-- 		server = {
	-- 			on_attach = function(client, bufnr)
	-- 				-- require("lsp-inlayhints").on_attach(client, bufnr)
	-- 				vim.lsp.inlay_hint.enable(bufnr, true)
	-- 			end,
	-- 		},
	-- 	}
	-- end,
}
