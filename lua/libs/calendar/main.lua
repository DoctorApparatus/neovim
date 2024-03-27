local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local calendar = {
	state = {
		year = os.date("*t").year,
		month = os.date("*t").month,
		-- Initialize selected_day to the current day
		selected_day = os.date("*t").day,
		-- Initialize cursor_pos to map to the current day in the month
		cursor_pos = os.date("*t").day,
		width = 20,
		height = 10,
	},
	popup = nil,
	on_date_select = nil, -- Callback function placeholder
}

function calendar:get_days_in_month(month, year)
	local days = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
	if month == 2 and (year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)) then
		return 29
	else
		return days[month]
	end
end

function calendar:get_first_weekday(month, year)
	return tonumber(os.date("*t", os.time({ year = year, month = month, day = 1 })).wday)
end

function calendar:generate_calendar_content()
	local month_names = {
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December",
	}
	local days_in_month = self:get_days_in_month(self.state.month, self.state.year)
	local first_weekday = self:get_first_weekday(self.state.month, self.state.year)
	local total_days = (first_weekday - 1) + days_in_month
	local weeks_needed = math.ceil(total_days / 7)

	-- Calculate spacing
	local day_width = math.floor((self.state.width - 4) / 7)
	local vertical_space = math.max(0, self.state.height - weeks_needed - 4) -- Adjusted for two extra header rows
	local space_per_week = weeks_needed > 1 and math.floor(vertical_space / (weeks_needed - 1)) or 0

	local content = {}
	local week = {}
	local day_format = "%-" .. day_width .. "s"

	-- Calculate total width for content alignment, assuming padding
	local total_width = self.state.width - 4 -- Adjust if different padding
	-- Center Year and Month at the top
	local year_str = tostring(self.state.year)
	local month_str = month_names[self.state.month]
	local year_padding = math.floor((total_width - string.len(year_str)) / 2)
	local month_padding = math.floor((total_width - string.len(month_str)) / 2)
	table.insert(content, string.rep(" ", year_padding) .. year_str)
	table.insert(content, string.rep(" ", month_padding) .. month_str)

	-- Generate header for days of the week
	local header = { "Su", "Mo", "Tu", "We", "Th", "Fr", "Sa" }
	for i, day in ipairs(header) do
		header[i] = string.format(day_format, day)
	end
	table.insert(content, table.concat(header, " "))

	-- Generate days
	for i = 1, (first_weekday - 1) % 7 do
		table.insert(week, string.format(day_format, " "))
	end

	for day = 1, days_in_month do
		local day_str =
			string.format(day_format, day == self.state.selected_day and "[" .. tostring(day) .. "]" or tostring(day))
		table.insert(week, day_str)
		if #week == 7 or day == days_in_month then
			table.insert(content, table.concat(week, " "))
			week = {}
			-- Add vertical spacing between weeks
			if space_per_week > 0 and #content < self.state.height - 3 then -- Adjusted for header rows
				for _ = 1, space_per_week do
					table.insert(content, "")
				end
			end
		end
	end

	return content
end

function calendar:refresh_calendar()
	if self.popup and self.popup.bufnr then
		local content = self:generate_calendar_content()
		vim.api.nvim_buf_set_lines(self.popup.bufnr, 0, -1, false, content)
	end
end

function calendar:handle_navigation(key)
	local days_in_month = self:get_days_in_month(self.state.month, self.state.year)

	if key == "left" then
		self.state.selected_day = math.max(1, self.state.selected_day - 1)
	elseif key == "right" then
		self.state.selected_day = math.min(days_in_month, self.state.selected_day + 1)
	elseif key == "up" then
		self.state.selected_day = math.max(1, self.state.selected_day - 7)
	elseif key == "down" then
		self.state.selected_day = math.min(days_in_month, self.state.selected_day + 7)
	elseif key == "n" then
		-- Move to the next month
		if self.state.month == 12 then
			self.state.month = 1
			self.state.year = self.state.year + 1
		else
			self.state.month = self.state.month + 1
		end
		self.state.selected_day = 1 -- Reset selected day to 1 to avoid out-of-range errors
	elseif key == "p" then
		-- Move to the previous month
		if self.state.month == 1 then
			self.state.month = 12
			self.state.year = self.state.year - 1
		else
			self.state.month = self.state.month - 1
		end
		self.state.selected_day = 1 -- Reset selected day to 1
	elseif key == "N" then
		-- Move to the next year
		self.state.year = self.state.year + 1
		self.state.selected_day = 1 -- Reset selected day to 1
	elseif key == "P" then
		-- Move to the previous year
		self.state.year = self.state.year - 1
		self.state.selected_day = 1 -- Reset selected day to 1
	end

	-- Adjust days_in_month in case of month or year change
	days_in_month = self:get_days_in_month(self.state.month, self.state.year)
	-- Ensure selected_day is within the new month's day range
	self.state.selected_day = math.min(self.state.selected_day, days_in_month)

	self:refresh_calendar()
end

function calendar:handle_selected_day()
	-- Prepare the date string
	local date_str = string.format("%04d-%02d-%02d", self.state.year, self.state.month, self.state.selected_day)

	-- Invoke the callback with the selected date if it's set
	if self.on_date_select and type(self.on_date_select) == "function" then
		self.on_date_select(date_str)
	end

	-- Close the popup after invoking the callback
	if self.popup then
		self.popup:unmount()
	end
end

function calendar:open(custom_width, custom_height, callback)
	self.on_date_select = callback
	-- Allow custom size parameters to adjust the calendar's width and height
	self.state.width = custom_width or self.state.width
	self.state.height = custom_height or self.state.height

	local content = self:generate_calendar_content()
	-- Calculate dynamic height based on the content or use custom_height if provided
	local dynamic_height = custom_height or (#content + 2) -- Adding 2 for padding or header/footer space

	self.popup = Popup({
		enter = true,
		focusable = false,
		border = "single",
		position = "50%",
		size = {
			width = self.state.width,
			height = dynamic_height,
		},
		buf_options = {
			modifiable = true,
			readonly = false,
		},
	})

	self.popup:mount()

	vim.api.nvim_create_autocmd("WinEnter", {
		buffer = self.popup.bufnr,
		callback = function()
			-- Attempt to change cursor shape or move it; specifics depend on terminal support
			vim.cmd("set guicursor=a:hor20") -- Example for GUI Neovim clients
		end,
	})

	vim.api.nvim_create_autocmd("WinLeave", {
		buffer = self.popup.bufnr,
		callback = function()
			-- Revert cursor changes when leaving the popup window
			vim.cmd("set guicursor=a:block") -- Revert for GUI Neovim clients
		end,
	})

	self.popup:on(event.BufLeave, function()
		self.popup:unmount()
	end)

	vim.api.nvim_buf_set_lines(self.popup.bufnr, 0, -1, false, content)

	local mappings = {
		["h"] = function()
			self:handle_navigation("left")
		end,
		["j"] = function()
			self:handle_navigation("down")
		end,
		["k"] = function()
			self:handle_navigation("up")
		end,
		["l"] = function()
			self:handle_navigation("right")
		end,
		["n"] = function()
			self:handle_navigation("n")
		end,
		["p"] = function()
			self:handle_navigation("p")
		end,
		["N"] = function()
			self:handle_navigation("N")
		end,
		["P"] = function()
			self:handle_navigation("P")
		end,
		["<CR>"] = function()
			self:handle_selected_day()
		end,
	}

	for key, handler in pairs(mappings) do
		self.popup:map("n", key, handler, { noremap = true, nowait = true })
	end
end

return calendar
