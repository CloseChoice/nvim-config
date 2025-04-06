return {
	-- Main DAP plugin
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Set up DAP UI
			dapui.setup()

			-- Set up virtual text
			require("nvim-dap-virtual-text").setup()

			-- Connect DAP UI to DAP events
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Set up key mappings similar to pdb
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint (b)" })
			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue (c)" })
			vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "Next (n)" })
			vim.keymap.set("n", "<leader>ds", dap.step_into, { desc = "Step (s)" })
			vim.keymap.set("n", "<leader>dr", dap.step_out, { desc = "Return/Step Out (r)" })
			vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Quit (q)" })
			vim.keymap.set("n", "<leader>dp", function()
				dapui.float_element("scopes", { enter = true })
			end, { desc = "Print (p)" })
			vim.keymap.set("n", "<leader>dl", function()
				dapui.float_element("stacks", { enter = true })
			end, { desc = "Where/List (l)" })
			vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })

			-- Add pdb-like commands that can be used when debugging
			vim.api.nvim_create_user_command("DapContinue", function()
				dap.continue()
			end, {})
			vim.api.nvim_create_user_command("DapNext", function()
				dap.step_over()
			end, {})
			vim.api.nvim_create_user_command("DapStep", function()
				dap.step_into()
			end, {})
			vim.api.nvim_create_user_command("DapReturn", function()
				dap.step_out()
			end, {})
			vim.api.nvim_create_user_command("DapQuit", function()
				dap.terminate()
			end, {})
		end,
	},

	-- Python debugger setup
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			-- Path to debugpy from Mason
			local path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(path)

			-- Key mappings for Python debugging
			vim.keymap.set("n", "<leader>dt", function()
				require("dap-python").test_method()
			end, { desc = "Debug Test Method" })

			vim.keymap.set("n", "<leader>dC", function()
				require("dap-python").test_class()
			end, { desc = "Debug Test Class" })

			vim.keymap.set("n", "<leader>df", function()
				require("dap").run({
					type = "python",
					request = "launch",
					name = "Debug Current File",
					program = "${file}",
					pythonPath = function()
						-- Try to detect python from current environment
						local venv = os.getenv("VIRTUAL_ENV")
						if venv then
							return venv .. "/bin/python"
						end
						return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
					end,
				})
			end, { desc = "Debug File" })
		end,
	},
}
