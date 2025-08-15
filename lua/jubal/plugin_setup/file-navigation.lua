return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
	config = function()
		local telescope_builtin = require('telescope.builtin')
		local telescope_actions = require('telescope.actions')
		local telescope_dropdown = require('telescope.themes').get_dropdown

		-- See `:help telescope` and `:help telescope.setup()`
		-- See `:help telescope.builtin`
		require('telescope').setup {
			defaults = {
				mappings = {
					i = {
						['<C-u>'] = false,
						['<C-d>'] = false,
						['<C-q>'] = telescope_actions.smart_send_to_qflist + telescope_actions.open_qflist
					},
					n = {
						['<C-q>'] = telescope_actions.smart_send_to_qflist + telescope_actions.open_qflist
					}
				},
			},
		}

		-- Enable telescope fzf native, if installed
		-- pcall(require('telescope').load_extension, 'fzf')

		vim.keymap.set('n', '<leader>?', telescope_builtin.oldfiles, { desc = '[?] Find recently opened files' })
		vim.keymap.set('n', '<leader><space>', function()
			telescope_builtin.buffers(telescope_dropdown {
				sort_mru = true,
				ignore_current_buffer = true,
				previewer = false,
			})
		end, { desc = '[ ] Find existing buffers' })
		vim.keymap.set('n', '<leader>/', function()
			telescope_builtin.current_buffer_fuzzy_find(telescope_dropdown {
				winblend = 10,
				previewer = false,
			})
		end, { desc = '[/] Fuzzily search in current buffer' })
		vim.keymap.set('n', '<leader>gf', telescope_builtin.git_files, { desc = 'Search [G]it [F]iles' })
		vim.keymap.set('n', '<leader>p', function()
			telescope_builtin.find_files(telescope_dropdown {
				find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
				ignore_current_buffer = true,
				previewer = false,
			})
		end, { desc = 'Search Files' })
		vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp' })
		vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch current [W]ord' })
		vim.keymap.set('n', '<leader>sg', function()
			telescope_builtin.live_grep({ layout_strategy = 'vertical' })
		end, { desc = '[S]earch by [G]rep' })
		vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
		vim.keymap.set('n', '<leader>sq', telescope_builtin.quickfix, { desc = '[S]earch [Q]uickfix' })
	end
	},
}
