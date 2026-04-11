--- Remote Syncing on Save
local projects = {
  {
    local_path = '/home/artyom/projects/tts-1102/',
    remote_path = 'nvidia@10.1.245.77:projects/tts-1102',
  },
  {
    local_path = '/home/artyom/projects/tts-0040/',
    remote_path = 'nvidia@10.1.245.77:projects/tts-0040',
  },
}

local rsync_command = 'rsync -rtvzl --no-perms --no-owner --no-group %s %s --exclude __pycache__ --exclude "*.pyc" --exclude "*.docx" --exclude docs'

for _, project in ipairs(projects) do
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = project.local_path .. '*',
    callback = function()
      local command = string.format(rsync_command, project.local_path, project.remote_path)
      vim.fn.jobstart(command, {
        on_exit = function(_, exit_code, _)
          if exit_code == 0 then
            print('File synced successfully!')
          else
            print('Error syncing file. Exit code: ' .. exit_code)
          end
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
