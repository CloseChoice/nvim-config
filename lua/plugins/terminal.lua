return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			-- Size can be a number or function
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			open_mapping = [[<c-\>]], -- Ctrl+\ opens the terminal
			hide_numbers = true, -- Hide line numbers in terminal
			shade_terminals = true, -- Darken the terminal background
			start_in_insert = true, -- Start in insert mode
			insert_mappings = true, -- Enable mappings in insert mode
			terminal_mappings = true, -- Enable mappings in terminal mode
			persist_size = true,
			persist_mode = true, -- Remember last mode when opening
			direction = "horizontal", -- 'horizontal', 'vertical', 'float', 'tab'
			close_on_exit = true, -- Close terminal when process exits
			shell = vim.o.shell, -- Default shell
			float_opts = {
				border = "curved",
				winblend = 0,
			},
		})

		-- Define key mappings for better terminal experience
		function _G.set_terminal_keymaps()
			local opts = { buffer = 0 }
			-- ESC goes to normal mode in terminal
			vim.keymap.set("t", "<esc>", [[<C-n><C-n>]], opts)
			-- Make terminal navigation easier
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
		end

		-- Auto command to set terminal keymaps
		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		-- Numbered terminal instances (1-9)
		local Terminal = require("toggleterm.terminal").Terminal

		-- Function to create toggle handlers
		local function create_terminal_toggle(id)
			return function()
				local term = Terminal:new({
					count = id,
					direction = "horizontal",
				})
				term:toggle()
			end
		end

		-- Create and map multiple terminals
		for i = 1, 3 do
			vim.keymap.set(
				"n",
				string.format("<leader>%d", i),
				create_terminal_toggle(i),
				{ desc = string.format("Terminal %d", i) }
			)
		end

		-- Create special Python terminal
		local python_term = Terminal:new({
			cmd = "python",
			hidden = true,
			direction = "horizontal",
			count = 100, -- Unique identifier
		})

		-- Function to run Python files
		local function run_python()
			vim.cmd("write") -- Save the file
			python_term:shutdown()
			python_term = Terminal:new({
				cmd = "python " .. vim.fn.expand("%:p"),
				direction = "horizontal",
				count = 100,
				close_on_exit = false,
			})
			python_term:toggle()
		end

		-- Map key to run current Python file
		vim.keymap.set("n", "<leader>r", run_python, { desc = "Run Python file" })
	end,
}
