-- In your lua/plugins.lua file or wherever you configure Lazy plugins
return {
	{
		"junegunn/fzf",
		build = function()
			vim.fn["fzf#install"]()
		end,
	},
	{
		"junegunn/fzf.vim",
		dependencies = { "junegunn/fzf" },
		config = function()
			-- FZF Configuration
			vim.env.FZF_DEFAULT_COMMAND = 'find . -type f -not -path "*/\\.git/*" -not -path "*/node_modules/*"'
			-- Layout configuration

			vim.g.fzf_layout = { down = "~40%" }

			-- Define action key mappings
			vim.g.fzf_action = {
				["ctrl-t"] = "tab split",
				["ctrl-s"] = "split",
				["ctrl-v"] = "vsplit",
			}

			-- Set up key mappings
			vim.keymap.set("n", "<leader>f", ":Files<CR>", { silent = true })
			vim.keymap.set("n", "<leader>b", ":Buffers<CR>", { silent = true })
			vim.keymap.set("n", "<leader>r", ":Rg<CR>", { silent = true })
			vim.keymap.set("n", "<leader>h", ":History<CR>", { silent = true })
		end,
	},
}
