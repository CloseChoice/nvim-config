-- Ensure Rust toolchain is in PATH
vim.env.PATH = vim.env.PATH .. ":/home/tobias/.cargo/bin"

require("config.lazy")
require("maps")
