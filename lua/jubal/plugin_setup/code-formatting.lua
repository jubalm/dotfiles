return {
	-- language server
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'williamboman/mason.nvim',          config = true },
			{ 'williamboman/mason-lspconfig.nvim' },
			{ 'j-hui/fidget.nvim',                tag = 'v1.4.0', opts = {} },
			{ 'folke/neodev.nvim' },
			{ 'nvim-telescope/telescope.nvim' }
		},
		config = function()
			local telescope_builtin = require 'telescope.builtin'
			--  This function gets run when an LSP connects to a particular buffer.
			local on_attach = function(_, bufnr)
				local nmap = function(keys, func, desc)
					if desc then
						desc = 'LSP: ' .. desc
					end

					vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
				end

				nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
				nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

				nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
				nmap('gr', telescope_builtin.lsp_references, '[G]oto [R]eferences')
				nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
				nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
				nmap('<leader>ds', telescope_builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
				nmap('<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

				-- See `:help K` for why this keymap
				nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
				nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

				-- Lesser used LSP functionality
				nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
				nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
				nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
				nmap('<leader>wl', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, '[W]orkspace [L]ist Folders')

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
					vim.lsp.buf.format()
				end, { desc = 'Format current buffer with LSP' })

				nmap('<leader>fd', vim.lsp.buf.format, '[F]ormat [D]ocument')

				local group = vim.api.nvim_create_augroup("LSPDocumentHighlight", {})

				-- Hightlight references under the cursor
				local highlightOnHold = function()
					vim.defer_fn(function()
						vim.lsp.buf.document_highlight()
					end
					, 1500)
				end

				vim.api.nvim_create_autocmd({ "CursorHold" }, {
					buffer = bufnr,
					group = group,
					callback = highlightOnHold
				})
				vim.api.nvim_create_autocmd({ "CursorMoved" }, {
					buffer = bufnr,
					group = group,
					callback = vim.lsp.buf.clear_references
				})
			end

			-- Setup neovim lua configuration
			require('neodev').setup()

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
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
				on_attach = on_attach,
			})

			-- Configure specific servers
			vim.lsp.config('biome', {
				root_markers = { 'package.json', 'node_modules', '.git' },
			})

			vim.lsp.config('ts_ls', {
				capabilities = capabilities,
				on_attach = on_attach,
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

	-- Commenting
	{ 'numToStr/Comment.nvim', opts = {} },

	-- Code Folding
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
			require('ufo').setup()
		end
	},

	-- Auto-detect indentation, supports .editorconfig
	{ 'tpope/vim-sleuth' }
}
