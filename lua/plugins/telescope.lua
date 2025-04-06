return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-fzf-native.nvim",
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						prompt_position = "top",
					},
				},
			},
		})

		local builtin = require("telescope.builtin")

		-- LSP navigation
		vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to definition" })
		vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Find references" })
		vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "Go to implementation" })
		vim.keymap.set("n", "<leader>sd", builtin.lsp_document_symbols, { desc = "Document symbols" })
		vim.keymap.set("n", "<leader>sw", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })
	end,
}
