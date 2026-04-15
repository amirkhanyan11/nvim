--- Remote Syncing on Save
local projects = {
  -- for testing purposes only
  {
    local_path = '/home/artyom/projects/tts-1102/',
    remote_path = 'nvidia@ep3:projects/tts-1102',
    rsync_flags = '--exclude __pycache__ --exclude "*.pyc" --exclude "*.docx" --exclude docs',
  },
  {
    local_path = '/home/artyom/projects/tts-0040/',
    remote_path = 'nvidia@thor77:projects/tts-0040',
    rsync_flags = '--exclude __pycache__ --exclude "*.pyc" --exclude "*.docx" --exclude docs',
  },
}

local rsync_command = 'rsync -rtvzl --no-perms --no-owner --no-group %s %s %s'


-- Spinner Configuration
local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local active_timers = {}

local function stop_spinner(bufnr)
  if active_timers[bufnr] then
    active_timers[bufnr]:stop()
    active_timers[bufnr]:close()
    active_timers[bufnr] = nil
  end
end

local function start_spinner(bufnr)
  stop_spinner(bufnr) -- Clear existing if any
  local frame = 1
  local timer = vim.loop.new_timer()
  active_timers[bufnr] = timer

  timer:start(0, 100, vim.schedule_wrap(function()
    if active_timers[bufnr] then
      vim.api.nvim_echo({{ string.format("%s Syncing...", spinner_frames[frame]), "None" }}, false, {})
      frame = (frame % #spinner_frames) + 1
    end
  end))
end

for _, project in ipairs(projects) do
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = project.local_path .. '*',
    callback = function()
      local command = string.format(rsync_command, project.local_path, project.remote_path, project.rsync_flags)
      bufnr = vim.api.nvim_get_current_buf()
      start_spinner(bufnr)
      vim.fn.jobstart(command, {
        on_exit = function(_, exit_code, _)
          if exit_code == 0 then
            print('File synced successfully!')
          else
            print('Error syncing file. Exit code: ' .. exit_code)
          end
        stop_spinner(bufnr)
        end,
      })
    end,
  })
end

--- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/^\s\+$//e]],
})
