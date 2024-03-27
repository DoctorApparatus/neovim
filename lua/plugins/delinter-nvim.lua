return {
	dir = "/home/doctorapparatus/Code/Projects/Lua/delinter-nvim",
	config = function()
		require("delinter-nvim").setup({
			-- Assuming 'filetypes' is the correct key based on our discussion
			filetypes = {
				"typescriptreact",
				-- Add other filetypes as needed
			},
			debug = false,
		})
	end,
}
