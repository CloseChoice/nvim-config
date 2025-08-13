return {
	"sindrets/diffview.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local diffview = require("diffview")

		diffview.setup({
			diff_binaries = false,
			enhanced_diff_hl = false,
			use_icons = true,
			icons = {
				folder_closed = "",
				folder_open = "",
			},
			signs = {
				fold_closed = "",
				fold_open = "",
				done = "✓",
			},
			view = {
				merge_tool = {
					layout = "diff3_mixed",
					disable_diagnostics = true,
				},
			},
			file_panel = {
				listing_style = "tree",
				tree_options = {
					flatten_dirs = true,
					folder_statuses = "only_folded",
				},
			},
			default_args = {
				DiffviewOpen = {},
				DiffviewFileHistory = {},
			},
			hooks = {},
			keymaps = {
				view = {
					["q"] = "<Cmd>DiffviewClose<CR>",
				},
				file_panel = {
					["q"] = "<Cmd>DiffviewClose<CR>",
				},
				file_history_panel = {
					["q"] = "<Cmd>DiffviewClose<CR>",
				},
			},
		})

		-- Add key mappings
		vim.keymap.set("n", "<leader>dv", "<Cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
		vim.keymap.set("n", "<leader>dh", "<Cmd>DiffviewFileHistory<CR>", { desc = "Open File History" })
		vim.keymap.set("n", "<leader>dc", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" })
	end,
}
