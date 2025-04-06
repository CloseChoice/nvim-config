return {
	"github/copilot.vim",
	config = function()
		-- Basic configuration
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_assume_mapped = true
		vim.g.copilot_tab_fallback = ""

		-- Set up custom keybindings
		vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
		vim.api.nvim_set_keymap("i", "<C-H>", "copilot#Previous()", { silent = true, expr = true })
		vim.api.nvim_set_keymap("i", "<C-L>", "copilot#Next()", { silent = true, expr = true })

		-- Enable Copilot for specific filetypes (optional)
		vim.cmd([[
      let g:copilot_filetypes = {
          \ '*': v:true,
          \ 'help': v:false,
          \ 'gitcommit': v:false,
          \ 'markdown': v:false,
          \ }
    ]])
	end,
}
