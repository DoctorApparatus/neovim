return {
	"folke/edgy.nvim",
	event = "VeryLazy",
	enabled = false,
	opts = {
		left = {
			-- Neo-tree filesystem always takes half the screen height
			{
				title = "Neo-Tree",
				ft = "neo-tree",
				filter = function(buf)
					return vim.b[buf].neo_tree_source == "filesystem"
				end,
				size = { height = 0.5 },
			},
			-- {
			-- 	title = "Neo-Tree Git",
			-- 	ft = "neo-tree",
			-- 	filter = function(buf)
			-- 		return vim.b[buf].neo_tree_source == "git_status"
			-- 	end,
			-- 	pinned = true,
			-- 	open = "Neotree position=right git_status",
			-- },
			-- {
			-- 	title = "Neo-Tree Buffers",
			-- 	ft = "neo-tree",
			-- 	filter = function(buf)
			-- 		return vim.b[buf].neo_tree_source == "buffers"
			-- 	end,
			-- 	pinned = true,
			-- 	open = "Neotree position=top buffers",
			-- },
			{
				ft = "Outline",
				pinned = true,
				open = "Outline",
			},
			-- any other neo-tree windows
			"neo-tree",
		},
		bottom = {
			{
				ft = "toggleterm",
				size = { height = 0.2 },
				-- exclude floating windows
				filter = function(_buf, win)
					return vim.api.nvim_win_get_config(win).relative == ""
				end,
			},
			{
				ft = "lazyterm",
				title = "LazyTerm",
				size = { height = 0.4 },
				filter = function(buf)
					return not vim.b[buf].lazyterm_cmd
				end,
			},
			"Trouble",
			{ ft = "qf", title = "QuickFix" },
			{
				ft = "help",
				size = { height = 20 },
				-- only show help buffers
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
			{ ft = "spectre_panel", size = { height = 0.4 } },
		},
		right = {},
		top = {},

		options = {
			left = { size = 30 },
			bottom = { size = 10 },
			right = { size = 30 },
			top = { size = 10 },
		},

		animate = {
			enabled = true,
			fps = 100,
			cps = 1000,
			on_begin = function()
				vim.g.minianimate_disable = true
			end,
			on_end = function()
				vim.g.minianimate_disable = false
			end,

			spinner = {
				frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
				interval = 80,
			},
		},

		exit_when_last = false,

		close_when_all_hidden = true,

		wo = {

			winbar = true,
			winfixwidth = true,
			winfixheight = false,
			winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal",
			spell = false,
			signcolumn = "no",
		},

		keys = {

			["q"] = function(win)
				win:close()
			end,

			["<c-q>"] = function(win)
				win:hide()
			end,

			["Q"] = function(win)
				win.view.edgebar:close()
			end,

			["]w"] = function(win)
				win:next({ visible = true, focus = true })
			end,

			["[w"] = function(win)
				win:prev({ visible = true, focus = true })
			end,

			["]W"] = function(win)
				win:next({ pinned = false, focus = true })
			end,

			["[W"] = function(win)
				win:prev({ pinned = false, focus = true })
			end,

			["<c-w>>"] = function(win)
				win:resize("width", 2)
			end,

			["<c-w><lt>"] = function(win)
				win:resize("width", -2)
			end,

			["<c-w>+"] = function(win)
				win:resize("height", 2)
			end,

			["<c-w>-"] = function(win)
				win:resize("height", -2)
			end,

			["<c-w>="] = function(win)
				win.view.edgebar:equalize()
			end,
		},
		icons = {
			closed = " ",
			open = " ",
		},

		fix_win_height = vim.fn.has("nvim-0.10.0") == 0,
	},
}
