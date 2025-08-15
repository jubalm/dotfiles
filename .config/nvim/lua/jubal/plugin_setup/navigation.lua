return {
	-- Fuzzy finder for files, buffers, grep, git files
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',	-- Utility library dependency
		},
	config = function()
		local telescope_actions = require('telescope.actions')
		
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
	end
	},
}
