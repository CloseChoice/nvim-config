return {
	"dmtrKovalenko/fff.nvim",
	build = function()
		require("fff.download").download_or_build_binary()
	end,
	lazy = false,
	opts = {
		debug = {
			enabled = false,
			show_scores = false,
		},
	},
	keys = {
		{
			"<leader>f",
			function()
				require("fff").find_files()
			end,
			desc = "FFFind files",
		},
		{
			"<leader>r",
			function()
				require("fff").live_grep()
			end,
			desc = "LiFFFe grep",
		},
		{
			"<leader>fz",
			function()
				require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
			end,
			desc = "Live fffuzzy grep",
		},
		{
			"<leader>fc",
			function()
				require("fff").live_grep({ query = vim.fn.expand("<cword>") })
			end,
			desc = "Search current word",
		},
		{
			"<leader>fd",
			function()
				require("fff").live_grep({ cwd = vim.fn.expand("%:p:h") })
			end,
			desc = "Live grep in current file's directory",
		},
		{
			"<leader>fF",
			function()
				vim.ui.input({ prompt = "Find files in dir: ", completion = "dir", default = "" }, function(dir)
					if dir and dir ~= "" then
						require("fff").find_files_in_dir(vim.fn.fnamemodify(dir, ":p"))
					end
				end)
			end,
			desc = "Find files in directory",
		},
	},
}
