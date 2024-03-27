return {
	"chrisgrieser/nvim-spider",
	config = function()
		require("spider").setup({
			skipInsignificantPunctuation = true,
			subwordMovement = true,
			customPatterns = {}, -- check Custom Movement Patterns for details
		})
	end,
}
