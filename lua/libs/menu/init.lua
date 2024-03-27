local M = {}

M.toggle_left_buffer = function(size, direction)
	local bufname = "toggle_buffer_" .. direction
	local buflisted = vim.fn.bufexists(bufname)
	local winfound = false

	-- Check if the buffer is already open in a window
	for _, win in ipairs(vim.fn.getwininfo()) do
		if vim.fn.bufname(win.bufnr) == bufname then
			winfound = true
			-- Close the window that contains the buffer
			vim.api.nvim_win_close(win.winid, true)
			return
		end
	end

	if not winfound then
		-- Determine the command to use based on direction
		local split_cmd = direction == "top" and "topleft split"
			or direction == "bottom" and "botright split"
			or direction == "left" and "topleft vsplit"
			or direction == "right" and "botright vsplit"

		-- Execute the split command
		vim.cmd(split_cmd)

		local win = vim.api.nvim_get_current_win()
		if buflisted == 0 then
			-- Create a new buffer if it doesn't exist
			vim.api.nvim_buf_set_name(0, bufname)
			-- Set buffer specific options here if needed
			vim.bo[0].buftype = "nofile"
			vim.bo[0].bufhidden = "hide"
			vim.bo[0].swapfile = false
		else
			-- Open the buffer in a new window if it exists but is not displayed
			vim.cmd("sbuffer " .. bufname)
		end

		-- Adjust the window size based on the direction and size parameter
		if direction == "left" or direction == "right" then
			vim.api.nvim_win_set_width(win, size)
		elseif direction == "top" or direction == "bottom" then
			vim.api.nvim_win_set_height(win, size)
		end
	end
end

return M
