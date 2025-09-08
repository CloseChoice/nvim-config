-- undotree.lua - Lazy.nvim plugin specification for undotree
-- Place this file in ~/.config/nvim/lua/plugins/undotree.lua

return {
	'mbbill/undotree',
	keys = {
		{ '<leader>u',  '<cmd>UndotreeToggle<cr>', desc = 'Toggle undotree' },
		{ '<leader>uf', '<cmd>UndotreeFocus<cr>',  desc = 'Focus undotree window' },
	},
	config = function()
		-- Configure undotree settings
		vim.g.undotree_WindowLayout = 2
		vim.g.undotree_SplitWidth = 30
		vim.g.undotree_SetFocusWhenToggle = 1
		vim.g.undotree_ShortIndicators = 1
		vim.g.undotree_DiffpanelHeight = 8
		vim.g.undotree_DiffAutoOpen = 1

		-- Enable persistent undo with project-specific directories
		vim.opt.undofile = true

		-- Create project-specific undo directory
		local function setup_undo_dir()
			local cwd = vim.fn.getcwd()
			-- Replace path separators and special chars to create safe directory name
			local safe_path = cwd:gsub('[/\\:]', '_'):gsub('^_', '')
			local undo_dir = vim.fn.expand('~/.config/nvim/undo/' .. safe_path)

			-- Create directory if it doesn't exist
			if vim.fn.isdirectory(undo_dir) == 0 then
				vim.fn.mkdir(undo_dir, 'p')
			end

			vim.opt.undodir = undo_dir
		end

		-- Set up undo directory for current project
		setup_undo_dir()

		-- Update undo directory when changing working directory
		vim.api.nvim_create_autocmd('DirChanged', {
			callback = setup_undo_dir,
			desc = 'Update undo directory for new project'
		})
	end,
}
