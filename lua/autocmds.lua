vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '/home/artyom/projects/tts-1102/*',
  callback = function()
    -- Changed vim.jobstart to vim.fn.jobstart
    vim.fn.jobstart('rsync -rtvzl --no-perms --no-owner --no-group /home/artyom/projects/tts-1102/ nvidia@10.1.22.211:projects/tts-1102 --exclude __pycache__ --exclude "*.pyc", --exclude "*.docx" --exclude docs', {
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


vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/^\s\+$//e]],
})
