function GetDiagnosticUnderCursor()
	local cursor_pos = vim.api.nvim_win_get_cursor(0) -- Get current cursor position
	local row = cursor_pos[1] - 1 -- Convert to 0-indexed row
	local col = cursor_pos[2] -- Column is already 0-indexed

	local diagnostics = vim.diagnostic.get(0, { lnum = row })

	-- Filter diagnostics to find those that include the cursor column
	local cursor_diagnostics = {}
	for _, diag in ipairs(diagnostics) do
		if col >= diag.col and col <= diag.end_col then
			table.insert(cursor_diagnostics, diag)
		end
	end

	-- Now you have a table of diagnostics under the cursor
	-- Example usage: Print the first diagnostic message if it exists
	if #cursor_diagnostics > 0 then
		-- print(cursor_diagnostics[1].message)
		-- You can return this or use it further as needed
		return cursor_diagnostics[1].message
	else
		print("No diagnostics under cursor")
		return nil
	end
end
