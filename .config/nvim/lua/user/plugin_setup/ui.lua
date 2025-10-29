return {
	-- Status line with git branch, diagnostics, file info
	{
		'nvim-lualine/lualine.nvim',
		config = function()
			local iceberg_dark = require 'lualine.themes.iceberg_dark'
			iceberg_dark.normal.c.bg = "#191919"

			require 'lualine'.setup {
				options = {
					icons_enabled = false,
					theme = iceberg_dark,
					component_separators = '',
					section_separators = '',
					globalstatus = true
				},
				sections = {
					lualine_a = {
						{
							'mode',
							fmt = function(str)
								return str:sub(1, 1)
							end
						}
					},
					lualine_b = { 'branch' },
					lualine_c = { { 'filename', path = 1 }, 'diff', 'diagnostics' },
					lualine_x = { 'encoding' }
				},
			}
		end
	},

	-- Keyboard shortcut hints
	{
		'folke/which-key.nvim',
		opts = {}
	},

}
