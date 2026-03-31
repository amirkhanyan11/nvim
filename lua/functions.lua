local M = {}

function M.diff_with_commit()
  local builtin = require('telescope.builtin')
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  builtin.git_commits({
    attach_mappings = function(prompt_bufnr, map)
      -- This function runs when you press <CR> (Enter)
      actions.select_default:replace(function()
        -- Get the selected entry
        local selection = action_state.get_selected_entry()

        -- Close the telescope window
        actions.close(prompt_bufnr)

        -- selection.value is the full commit hash
        if selection then
          require('gitsigns').diffthis(selection.value)
        end
      end)
      return true
    end,
  })
end

function M.live_multigrep(opts)
	local finders = require("telescope.finders")
	local make_entry = require("telescope.make_entry")
	local pickers = require("telescope.pickers")
	local conf = require("telescope.config").values

	opts = opts or {}
	opts.cwd = opts.cwd or vim.uv.cwd()

	local finder = finders.new_async_job({
		command_generator = function(prompt)
			if not prompt or prompt == "" then
				return nil
			end

			local pieces = vim.split(prompt, "  ")
			local args = { "rg" }

			if pieces[1] then
				table.insert(args, "-e")
				table.insert(args, pieces[1])
			end

			if pieces[2] then
				table.insert(args, "-g")
				table.insert(args, pieces[2])
			end

			return vim.tbl_flatten({
				args,
				{ "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
			})
		end,
		entry_maker = make_entry.gen_from_vimgrep(opts),
		cwd = opts.cwd,
	})


	pickers.new(opts, {
		prompt_title = "Live Grep",
		finder = finder,
		previewer = conf.grep_previewer(opts),
		sorter = require("telescope.sorters").empty(),
	}):find()

end

return M
