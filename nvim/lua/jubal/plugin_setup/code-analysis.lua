--------------------------
-- Highlight References --
--------------------------
local function setup_reference_highlight(bufnr, group)
	local function clear_highlights()
		pcall(vim.lsp.buf.clear_references)
	end

	local function highlight_references()
		clear_highlights()  -- Clear any existing highlights first
		vim.defer_fn(function()
			pcall(vim.lsp.buf.document_highlight)  -- Use pcall to handle any errors
		end, 800)
	end

	-- Set up autocommands with error handling
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
	-- language server
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'williamboman/mason.nvim', config = true },
			{ 'williamboman/mason-lspconfig.nvim' },
			{ 'j-hui/fidget.nvim', tag = 'v1.4.0', opts = {} },
			{ 'folke/neodev.nvim' },
			{ 'nvim-telescope/telescope.nvim' }
		},
		config = function()
			local keymap = require('jubal.keymap')

			local user_lsp_group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true })

			-- Add LSP keybindings and setup reference highlighting when an LSP attaches to a buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = user_lsp_group,
				callback = function(ev)
					local bufnr = ev.buf
					keymap.setup_lsp_keymaps(bufnr)
					setup_reference_highlight(bufnr, user_lsp_group)
				end,
			})

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
			})

			-- Configure specific servers
			vim.lsp.config('biome', {
				root_markers = { 'package.json', 'node_modules', '.git' },
			})

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
