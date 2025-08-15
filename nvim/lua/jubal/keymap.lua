-------------------------
-- Global Key Mappings --
-------------------------

-- Reset search
vim.keymap.set({ 'n' }, '/', '<cmd>:noh<cr>/', { noremap = true })

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

---------------------
-- LSP Keybindings --
---------------------

-------------------------
-- Telescope Keymappings --
-------------------------

local telescope_builtin = require('telescope.builtin')
local telescope_dropdown = require('telescope.themes').get_dropdown

-- File navigation
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

-- Search functionality
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', function()
	telescope_builtin.live_grep({ layout_strategy = 'vertical' })
end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sq', telescope_builtin.quickfix, { desc = '[S]earch [Q]uickfix' })

----------------------------
-- Diagnostic Navigation --
----------------------------

-- Diagnostic navigation keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

---------------------
-- LSP Keybindings --
---------------------

local M = {}

M.setup_lsp_keymaps = function(bufnr)
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

    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Formatting
    local formatLine = function()
        vim.lsp.buf.format({ range = { start = vim.fn.line("'<"), ['end'] = vim.fn.line("'>") } })
    end
    nmap('<leader>fd', vim.lsp.buf.format, '[F]ormat [D]ocument')
    vim.keymap.set('v', '<leader>fl', formatLine, { buffer = bufnr, desc = 'LSP: [F]ormat [L]Line' })
end

return M
