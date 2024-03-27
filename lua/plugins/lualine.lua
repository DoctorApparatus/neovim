return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local lint_progress = function()
			local linters = require("lint").get_running()
			if #linters == 0 then
				return "󰦕"
			end
			return "󱉶 " .. table.concat(linters, ", ")
		end

		require("lualine").setup({
			sections = { lualine_a = { lint_progress }, lualine_c = { "lsp_progress" }, lualine_x = { "tabnine" } },
		})
	end,
}
