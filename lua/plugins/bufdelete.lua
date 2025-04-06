return {
	"famiu/bufdelete.nvim",
	config = function()
		vim.keymap.set("n", "<C-q>", "<cmd>Bdelete<cr>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>bd", "<cmd>Bdelete<cr>", { noremap = true, silent = true })
	end,
}
