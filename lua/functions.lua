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

return M
