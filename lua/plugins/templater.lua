return {
	"DoctorApparatus/templater-nvim",
	config = function()
		require("templater-nvim").setup({})
		--
		-- INFO: Templates
		--
		local templating = require("templater-nvim")
		local function create_idea()
			local template_file = "idea.md"
			local date = os.date("%Y-%m-%d")
			local title = vim.fn.input("Title: ")
			local dest_path_with_filename = os.getenv("HOME") .. "/Notes/Ideas/" .. date .. "-" .. title .. ".md"
			local template_values = {
				title = title, -- The user-provided title
			}
			templating.create_and_open_file_with_custom_template(
				dest_path_with_filename,
				template_file,
				template_values
			)
		end
		vim.api.nvim_create_user_command("CreateIdea", function()
			create_idea()
		end, { nargs = 0 })

		local function create_interest_spark()
			local template_file = "interest_spark.md"
			local date = os.date("%Y-%m-%d")
			local title = vim.fn.input("Title: ")
			local dest_path_with_filename = os.getenv("HOME")
				.. "/Notes/Interest_Sparks/"
				.. date
				.. "-"
				.. title
				.. ".md"
			local template_values = {
				title = title, -- The user-provided title
			}
			templating.create_and_open_file_with_custom_template(
				dest_path_with_filename,
				template_file,
				template_values
			)
		end
		vim.api.nvim_create_user_command("CreateInterestSpark", function()
			create_interest_spark()
		end, { nargs = 0 })

		local function create_daily_todo()
			local template_file = "daily_todo.md"
			local date = os.date("%Y-%m-%d")
			local title = "TODO"
			local template_values = {
				title = title,
			}
			local dest_path_with_filename = os.getenv("HOME") .. "/Notes/TODO/" .. date .. "-" .. title .. ".md"
			templating.create_and_open_file_with_custom_template(
				dest_path_with_filename,
				template_file,
				template_values
			)
		end
		vim.api.nvim_create_user_command("CreateDailyTodo", function()
			create_daily_todo()
		end, { nargs = 0 })

		local function open_recent_todo_files()
			local format = "%Y-%m-%d"
			local path = os.getenv("HOME") .. "/Notes/TODO/"

			-- Calculate today and yesterday dates
			local today = os.date(format)
			local yesterday = os.date(format, os.time() - (24 * 60 * 60)) -- Subtract one day in seconds

			-- Construct file names
			local today_file = path .. today .. "-TODO.md"
			local yesterday_file = path .. yesterday .. "-TODO.md"

			-- Check if today's file exists, if not, create it with a template
			if not vim.fn.filereadable(today_file) then
				create_daily_todo()
			else
				vim.cmd("e " .. today_file) -- Just open today's file if it exists
			end

			-- Open files in Neovim
			vim.cmd("edit " .. yesterday_file)
			vim.cmd("vsplit " .. today_file) -- This opens the yesterday file in a horizontal split. Change to `vsplit` if you prefer a vertical split.
		end

		-- To use this function directly or bind it to a command/keymap in Neovim
		vim.api.nvim_create_user_command("OpenRecentTODOs", open_recent_todo_files, {})

		local function update_rating_in_file(star_rating)
			-- Get the current buffer
			local bufnr = vim.api.nvim_get_current_buf()

			-- Find the line with the rating in the YAML front matter
			for i = 1, vim.api.nvim_buf_line_count(bufnr) do
				local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
				if line:match("^rating:") then
					-- Replace the existing rating with the new one
					local new_line = "rating: " .. star_rating
					vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false, { new_line })
					print("Rating updated to: " .. star_rating)
					return
				end
			end
			print("Rating line not found in the YAML front matter.")
		end

		local function set_rating()
			local rating = vim.fn.input("Set the rating (1-5 stars): ", "")
			if not rating or rating == "" then
				print("No rating provided.")
				return
			end

			local num_rating = tonumber(rating)
			if not num_rating or num_rating < 1 or num_rating > 5 then
				print("Invalid rating. Please enter a number between 1 and 5.")
				return
			end

			local star_rating = string.rep("⭐", num_rating)
			update_rating_in_file(star_rating)
		end

		-- Add this function to Neovim commands to easily call it
		vim.api.nvim_create_user_command("SetRating", set_rating, {})

		local status_options = {
			"🌱", -- sapling
			"🪴", -- potted plant
			"🌿", -- leafy green
			"🌳", -- fully grown tree
		}

		local function set_status()
			print("Select the document growth stage:")
			for i, emoji in ipairs(status_options) do
				print(i .. ": " .. emoji)
			end

			local choice = tonumber(vim.fn.input("Enter your choice (1-4): "))
			if not choice or choice < 1 or choice > #status_options then
				print("Invalid choice. Operation cancelled.")
				return
			end

			local selected_status = status_options[choice]

			-- Logic to update status in the YAML front matter
			local bufnr = vim.api.nvim_get_current_buf()
			for i = 1, vim.api.nvim_buf_line_count(bufnr) do
				local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
				if line:match("^status:") then
					local new_line = "status: " .. selected_status
					vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false, { new_line })
					print("Status updated to: " .. selected_status)
					return
				end
			end
			print("Status line not found in the YAML front matter.")
		end

		vim.api.nvim_create_user_command("SetStatus", set_status, {})

		local function update_datetime_on_edit()
			-- Define the specified folder path
			local specified_folder = os.getenv("HOME") .. "/Notes/" -- Update this path

			-- Get the current file path
			local file_path = vim.fn.expand("%:p")

			-- Check if the file is in the specified folder or its subfolders
			---@diagnostic disable-next-line: param-type-mismatch
			if not string.match(file_path, "^" .. vim.pesc(specified_folder)) then
				return -- Exit the function if the file is outside the specified folder
			end

			local bufnr = vim.api.nvim_get_current_buf()
			local updated_line_index = nil
			local datetime = os.date("%Y-%m-%d %H:%M")

			for i, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
				if line:match("^updated:") then
					updated_line_index = i
					break
				end
			end

			if updated_line_index then
				vim.api.nvim_buf_set_lines(
					bufnr,
					updated_line_index - 1,
					updated_line_index,
					false,
					{ "updated: " .. datetime }
				)
			else
				print("No 'updated:' field found. Consider adding one.")
			end
		end

		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			pattern = "*.md",
			callback = update_datetime_on_edit,
		})

		-- Setup autocommand
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			pattern = "*.md",
			callback = update_datetime_on_edit,
		})

		function insert_template_into_current_buffer(template_file, template_values)
			-- Define function to load template
			local function load_template(template_path)
				local file, err = io.open(template_path, "r")
				if not file then
					print("Error loading template: " .. err)
					return nil
				end
				local content = file:read("*all")
				file:close()
				return content
			end

			local template_path = os.getenv("HOME") .. "/.config/nvim/templates/" .. template_file
			local template_content = load_template(template_path)
			if not template_content then
				print("Template loading failed.")
				return
			end

			-- Replace placeholders in the template
			for key, value in pairs(template_values) do
				template_content = template_content:gsub("{" .. key .. "}", value)
			end

			-- Insert the filled template into the current buffer
			local current_line = vim.api.nvim_win_get_cursor(0)[1] -- Get current line number
			local lines = vim.split(template_content, "\n")
			vim.api.nvim_buf_set_lines(0, current_line, current_line, false, lines)
		end

		vim.cmd([[colorscheme catppuccin-frappe]])

		local function open_or_create_todo_by_date()
			-- Prompt the user for a date
			local date = vim.fn.input("Enter date (YYYY-MM-DD): ")
			-- Validate the input date format
			if not date:match("^%d%d%d%d%-%d%d%-%d%d$") then
				print("Invalid date format. Please use YYYY-MM-DD.")
				return
			end

			local template_file = "daily_todo.md"
			if not date:match("^%d%d%d%d%-%d%d%-%d%d$") then
				print("Invalid date format. Please use YYYY-MM-DD.")
				return
			end

			local title = "TODO"
			local template_values = {
				title = title,
				date = date, -- Make sure your template can handle this new variable
			}
			local dest_path_with_filename = os.getenv("HOME") .. "/Notes/TODO/" .. date .. "-" .. title .. ".md"
			templating.create_and_open_file_with_custom_template(
				dest_path_with_filename,
				template_file,
				template_values
			)
		end

		-- Add the function to Neovim commands to easily call it
		vim.api.nvim_create_user_command("OpenTODOAtDate", open_or_create_todo_by_date, {})
	end,
}
