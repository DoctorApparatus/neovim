local M = {}

-- Surrounds the word under the cursor with [[ and ]]
M.SurroundWordWithBrackets = function()
	local word = vim.fn.expand("<cword>") -- Get the current word under the cursor
	local cursor_pos = vim.api.nvim_win_get_cursor(0) -- Save the cursor position
	local line = vim.api.nvim_get_current_line() -- Get the current line content
	local start_pos, end_pos = string.find(line, "%f[%w]" .. word .. "%f[%W]")

	-- Check if the word was found in the line
	if start_pos and end_pos then
		-- Surround the word with [[ and ]]
		local new_line = string.sub(line, 1, start_pos - 1) .. "[[" .. word .. "]]" .. string.sub(line, end_pos + 1)
		vim.api.nvim_set_current_line(new_line) -- Set the modified line

		-- Move cursor to the start of the surrounded word, adjusting for added brackets
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], start_pos + 1 })
	end
end

M.surroundWordInFiles = function(basePath, word)
	local function surroundWordInFile(filePath)
		local content = {}
		local file = io.open(filePath, "r") -- Open the file in read mode
		if file then
			for line in file:lines() do
				table.insert(content, line:gsub("(%f[%w]" .. word .. "%f[%W])", "[[%1]]"))
			end
			file:close()

			file = io.open(filePath, "w") -- Open the file in write mode to overwrite
			if file then
				for _, line in ipairs(content) do
					local written = file:write(line, "\n")
					if not written then
						print("Error writing to file: " .. filePath)
						break
					end
				end
				file:close()
			else
				print("Error opening file: " .. filePath)
			end
		else
			print("Error opening file: " .. filePath)
		end
	end

	local function scanDir(path)
		local req = luv.fs_scandir(path)
		if req then
			while true do
				local name, type = luv.fs_scandir_next(req)
				if not name then
					break
				end

				local fullPath = path .. "/" .. name
				if type == "directory" then
					scanDir(fullPath) -- Recursive call for directories
				else
					surroundWordInFile(fullPath) -- Process files
				end
			end
		end
	end

	scanDir(basePath)
end

return M
