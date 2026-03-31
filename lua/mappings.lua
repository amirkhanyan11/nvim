local map = vim.keymap.set

local functions = require('functions')

map('n', ';', ':', { desc = 'CMD enter command mode' })
map('i', 'jk', '<ESC>')

-- Misc

map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

map({ 'n', 'v' }, '<leader>y', [["+y]])
map('n', '<leader>Y', [["+Y]])

map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

map('x', '<leader>p', [["_dP]])

map('n', '<M-j>', '<cmd>cnext<cr>')
map('n', '<M-k>', '<cmd>cprev<cr>')


-- Netrw
map('n', '<leader>e', '<cmd>Explore<cr>', { desc = 'Explore file' })

--- Harpoon
map('n', '<leader>H', function() require('harpoon.mark').add_file() end, { desc = 'Harpoon add file' })

map('n', '<leader>h', function() require('harpoon.ui').toggle_quick_menu() end, { desc = 'Harpoon toggle quick menu' })

for i = 1, 4 do
  map('n', '<leader>' .. i, function() require('harpoon.ui').nav_file(i) end, { desc = 'Harpoon goto file' .. i })
end

-- Gitsigns
map('n', '<leader>dt', functions.diff_with_commit, { desc = 'Gitsings diff with commit' })

-- Telescope custom
map('n', '<leader>/', functions.live_multigrep, { desc = 'Live Grep' })
