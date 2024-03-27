return {
	"codota/tabnine-nvim",
	build = "./dl_binaries.sh",
	config = function()
		require("tabnine").setup({
			disable_auto_comment = true,
			accept_keymap = "<C-i>",
			dismiss_keymap = "<C-]>",
			debounce_ms = 800,
			suggestion_color = { gui = "#8080f0", cterm = 244 },
			exclude_filetypes = { "TelescopePrompt", "NvimTree" },
			log_file_path = nil, -- absolute path to Tabnine log file
		})
	end,
}
