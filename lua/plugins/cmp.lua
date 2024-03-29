return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"onsails/lspkind.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"rafamadriz/friendly-snippets",
		"hrsh7th/cmp-nvim-lsp-signature-help",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local mapping = {
			["<C-k>"] = cmp.mapping.select_prev_item(),
			["<C-j>"] = cmp.mapping.select_next_item(),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<C-e>"] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			["<CR>"] = cmp.mapping.confirm({ selected = true }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expandable() then
					luasnip.expand()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				-- elseif check_backspace() then
				-- 	fallback()
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
		}
		local window = {
			completion = cmp.config.window.bordered({
				winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
				col_offset = -3,
				side_padding = 0,
			}),
			documentation = cmp.config.window.bordered({
				winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
				col_offset = -3,
				side_padding = 0,
			}),
		}
		local formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
				local strings = vim.split(kind.kind, "%s", { trimempty = true })
				kind.kind = " " .. (strings[1] or " ") .. "  "
				kind.menu = "    (" .. (strings[2] or "") .. ")"

				return kind
			end,
		}
		local snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		}
		local sources = {
			{
				name = "nvim_lsp",
				entry_filter = function(entry, ctx)
					local kind = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]
					if kind == "Snippet" and ctx.prev_context.filetype == "java" then
						return false
					end
					if kind == "Text" then
						return false
					end
					return true
				end,
				priority = 1000,
				keyword_length = 1,
			},
			{
				name = "buffer",
				keyword_length = 2,
			},
			{
				name = "luasnip",
				priority = 1,
				keyword_length = 3,
			},
			{ name = "path" },
			{ name = "nvim_lua" },
			{ name = "calc" },
			{ name = "emoji" },
			{ name = "treesitter" },
			{ name = "obsidian" },
			{ name = "obsidian_new" },
			{ name = "obsidian_tags" },
			{ name = "crates" },
			{ name = "nvim_lsp_signature_help" },
			-- { name = "codi" },
			-- { name = "codeium" },
			{ name = "copilot", group_index = 2 },
			-- { name = "tmux" },
			-- { name = 'vsnip' },
			-- { name = 'cmp_tabnine' }
		}

		cmp.setup({
			window = window,
			formatting = formatting,
			mapping = mapping,
			snippet = snippet,
			sources = sources,
			confirm_opts = {
				behvaior = cmp.ConfirmBehavior.Replace,
				select = false,
			},
			experimental = {
				ghost_text = false,
			},
		})
	end,
}
