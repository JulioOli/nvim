require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- LSP keymappings
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to Definition" })
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "Go to References" })
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover Documentation" })
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code Action" })
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" })
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", { desc = "Format" })
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous Diagnostic" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next Diagnostic" })
map("n", "<leader>dl", "<cmd>lua vim.diagnostic.setloclist()<cr>", { desc = "Diagnostic List" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
