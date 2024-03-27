local M = {}

M.test_component = function()
	local n = require("nui-components")
	local renderer = n.create_renderer({
		width = 60,
		height = 8,
	})

	local signal = n.create_signal({
		is_loading = false,
		text = "nui.components",
	})

	local body = function()
		return n.rows(
			n.columns(
				{ flex = 0 },
				n.text_input({
					id = "text-input",
					autofocus = true,
					flex = 1,
					max_lines = 1,
				}),
				n.gap(1),
				n.button({
					label = "Send",
					padding = {
						top = 1,
					},
					on_press = function()
						signal.is_loading = true

						vim.defer_fn(function()
							local ref = renderer:get_component_by_id("text-input")
							signal.is_loading = false
							signal.text = ref:get_current_value()
						end, 2000)
					end,
				}),
				n.spinner({
					is_loading = signal.is_loading,
					padding = { top = 1, left = 1 },
					hidden = signal.is_loading:negate(),
				})
			),
			n.paragraph({
				lines = signal.text,
				align = "center",
				is_focusable = false,
			})
		)
	end

	renderer:render(body)
end

return M
