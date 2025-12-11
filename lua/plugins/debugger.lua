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

			-- C/C++/Rust debugger setup
			-- Path to codelldb from Mason
			local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
			local codelldb_path = extension_path .. "adapter/codelldb"

			-- Setup for C/C++/Rust
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = codelldb_path,
					args = { "--port", "${port}" },
				},
			}

			-- C/C++ configuration
			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
				{
					name = "Launch current file (build first)",
					type = "codelldb",
					request = "launch",
					program = function()
						local file = vim.fn.expand("%:p")
						local file_no_ext = vim.fn.expand("%:p:r")
						-- Compile with debug symbols
						local compile_cmd = string.format("g++ -g -o '%s' '%s'", file_no_ext, file)
						print("Compiling: " .. compile_cmd)
						vim.fn.system(compile_cmd)
						if vim.v.shell_error ~= 0 then
							print("Compilation failed!")
							return nil
						end
						return file_no_ext
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			-- C uses the same configuration as C++
			dap.configurations.c = dap.configurations.cpp

			-- Rust uses the same configuration as C++
			dap.configurations.rust = dap.configurations.cpp

			-- C/C++ specific keybindings
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "c", "cpp" },
				callback = function()
					vim.keymap.set("n", "<leader>df", function()
						-- Check if there are multiple configurations and let user choose
						dap.continue()
					end, { desc = "Debug C/C++ File", buffer = true })
				end,
			})

			-- Enable DAP logging for debugging issues
			-- View logs with: :lua vim.cmd('e ' .. vim.fn.stdpath('cache') .. '/dap.log')
			dap.set_log_level('INFO')
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

			-- Python with C++ debugging keymap (uses LLDB to debug both Python and C++)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "python",
				callback = function()
					vim.keymap.set("n", "<leader>dF", function()
						require("dap").run({
							type = "codelldb",
							request = "launch",
							name = "Debug Python + C++",
							program = function()
								local venv = os.getenv("VIRTUAL_ENV")
								if venv then
									return venv .. "/bin/python"
								end
								return vim.fn.exepath("python3") or "python3"
							end,
							args = { vim.fn.expand("%:p") },
							cwd = vim.fn.getcwd(),
							stopOnEntry = false,
						})
					end, { desc = "Debug Python + C++ (LLDB)", buffer = true })
				end,
			})
		end,
	},

}
