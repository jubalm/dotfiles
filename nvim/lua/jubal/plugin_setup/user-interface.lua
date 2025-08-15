return {

	-- Statusbar details
	{
		'nvim-lualine/lualine.nvim',
		config = function()
			local iceberg_dark = require 'lualine.themes.iceberg_dark'
			iceberg_dark.normal.c.bg = "#191919"

			require 'lualine'.setup {
				options = {
					icons_enabled = false,
					theme = iceberg_dark,
					-- theme = 'nord',
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

	-- Show keyboard hints
	{
		'folke/which-key.nvim',
		opts = {}
	},

	-- Git Indicators
	{ 'tpope/vim-fugitive' },
	{ 'tpope/vim-rhubarb' },
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			on_attach = function(bufnr)
				vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
					{ buffer = bufnr, desc = '[G]o to P]revious Hunk' })
				vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
					{ buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
				vim.keymap.set('n', '<leader>h', require('gitsigns').preview_hunk,
					{ buffer = bufnr, desc = '[P]review [H]unk' })
			end,
		},
	},

	-- Show indentation guides
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		opts = {
			indent = {
				char = '┆',
			},
			scope = {
				show_start = false
			}
		},
	},

	-- Show colors hints
	{
		'norcalli/nvim-colorizer.lua',
		config = function()
			require 'colorizer'.setup({
				'vim',
				'typescript',
				'css',
				'javascript',
			}, {
				mode = 'foreground'
			})
		end
	},
}
