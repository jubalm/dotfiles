-- Highlight References Helper
local function setup_reference_highlight(bufnr, group)
	local function clear_highlights()
		pcall(vim.lsp.buf.clear_references)
	end

	local function highlight_references()
		clear_highlights()
		vim.defer_fn(function()
			pcall(vim.lsp.buf.document_highlight)
		end, 800)
	end

	vim.api.nvim_create_autocmd({ "CursorHold" }, {
		buffer = bufnr,
		group = group,
		callback = highlight_references
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave", "InsertEnter" }, {
		buffer = bufnr,
		group = group,
		callback = clear_highlights
	})
end

return {
	-- Advanced syntax highlighting and code parsing
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',	-- Smart text objects (functions, classes, parameters)
		},
		build = ':TSUpdate',
		config = function()
			require 'nvim-treesitter.configs'.setup {
				modules = {},
				sync_install = false,
				ignore_install = {},
				ensure_installed = { "css", "javascript", "typescript", "tsx", "json", "html", "bash", "lua", "markdown", "markdown_inline" },
				auto_install = true,
				highlight = {
					enable = true,
					disable = { "yaml" }
				},
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = false,
						node_incremental = 'v',
						scope_incremental = false,
						node_decremental = 'V',
					},
				},
				playground = {
					enable = true
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							['aa'] = '@parameter.outer',
							['ia'] = '@parameter.inner',
							['af'] = '@function.outer',
							['if'] = '@function.inner',
							['ac'] = '@class.outer',
							['ic'] = '@class.inner',
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							[']m'] = '@function.outer',
							[']]'] = '@class.outer',
						},
						goto_next_end = {
							[']M'] = '@function.outer',
							[']['] = '@class.outer',
						},
						goto_previous_start = {
							['[m'] = '@function.outer',
							['[['] = '@class.outer',
						},
						goto_previous_end = {
							['[M'] = '@function.outer',
							['[]'] = '@class.outer',
						},
					},
					swap = {
						enable = true,
						swap_next = {
							['<leader>a'] = '@parameter.inner',
						},
						swap_previous = {
							['<leader>A'] = '@parameter.inner',
						},
					},
				},
			}
		end
	},

	-- Language Server Protocol configuration
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'williamboman/mason.nvim', config = true },			-- LSP server installer/manager
			{ 'williamboman/mason-lspconfig.nvim' },				-- Bridge between Mason and lspconfig
			{ 'j-hui/fidget.nvim', tag = 'v1.4.0', opts = {} },	-- LSP progress notifications
			{ 'folke/neodev.nvim' },								-- Enhanced Lua development for Neovim
			{ 'nvim-telescope/telescope.nvim' }
		},
		config = function()
			local keymap = require('user.keymap')

			local user_lsp_group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true })

			-- Add LSP keybindings and setup reference highlighting when an LSP attaches
			vim.api.nvim_create_autocmd('LspAttach', {
				group = user_lsp_group,
				callback = function(ev)
					local bufnr = ev.buf
					keymap.setup_lsp_keymaps(bufnr)
					setup_reference_highlight(bufnr, user_lsp_group)
				end,
			})

			require('neodev').setup()

			-- LSP capabilities with folding and highlighting support
			local defaultCapabilities = vim.lsp.protocol.make_client_capabilities()
			defaultCapabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
			defaultCapabilities.textDocument.documentHighlight = true

			local capabilities = require('cmp_nvim_lsp').default_capabilities(defaultCapabilities)

			local lspconfig = require('lspconfig')
			local mason_lspconfig = require('mason-lspconfig')

			mason_lspconfig.setup {
				ensure_installed = {}
			}

			-- Configure LSP servers using the new vim.lsp.config API
			vim.lsp.config('*', {
				capabilities = capabilities,
			})

			-- Biome (JavaScript/TypeScript formatter and linter)
			vim.lsp.config('biome', {
				root_markers = { 'package.json', 'node_modules', '.git' },
			})

			-- TypeScript Language Server
			vim.lsp.config('ts_ls', {
				capabilities = capabilities,
				settings = {
					typescript = {
						format = {
							insertSpaceAfterConstructor = true,
							insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = true
						}
					}
				},
				single_file_support = false,
			})
		end
	},

	-- Advanced code folding
	{
		'kevinhwang91/nvim-ufo',
		dependencies = {
			'kevinhwang91/promise-async'
		},
		config = function()
			vim.o.foldcolumn = '0'
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			-- Custom markdown folding function
			local function markdownFoldExpr()
				local line = vim.fn.getline(vim.v.lnum)
				local level = line:match('^(#+)')
				if level then
					return '>' .. #level
				else
					return '='
				end
			end

			-- Make the folding function globally available
			_G.markdownFoldExpr = markdownFoldExpr

			require('ufo').setup({
				fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
					local newVirtText = {}
					local suffix = (' 󰁂 %d '):format(endLnum - lnum)
					local sufWidth = vim.fn.strdisplaywidth(suffix)
					local targetWidth = width - sufWidth
					local curWidth = 0
					for _, chunk in ipairs(virtText) do
						local chunkText = chunk[1]
						local chunkWidth = vim.fn.strdisplaywidth(chunkText)
						if targetWidth > curWidth + chunkWidth then
							table.insert(newVirtText, chunk)
						else
							chunkText = truncate(chunkText, targetWidth - curWidth)
							local hlGroup = chunk[2]
							table.insert(newVirtText, { chunkText, hlGroup })
							chunkWidth = vim.fn.strdisplaywidth(chunkText)
							if curWidth + chunkWidth < targetWidth then
								suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
							end
							break
						end
						curWidth = curWidth + chunkWidth
					end
					table.insert(newVirtText, { suffix, 'MoreMsg' })
					return newVirtText
				end
			})

			-- Set up markdown folding expression
			vim.api.nvim_create_autocmd('FileType', {
				pattern = 'markdown',
				callback = function()
					vim.opt_local.foldmethod = 'expr'
					vim.opt_local.foldexpr = 'v:lua.markdownFoldExpr()'
				end
			})
		end
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

	-- Preview colors inline (CSS hex values, etc.)
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

	-- Git diff indicators in gutter
	{
		'lewis6991/gitsigns.nvim',
		opts = {
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
}