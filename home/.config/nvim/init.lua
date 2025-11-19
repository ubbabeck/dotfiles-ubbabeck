local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Compatibility shim for deprecated vim.lsp.buf_get_clients()
-- This fixes the deprecation warning from project.nvim plugin
-- vim.lsp.buf_get_clients([bufnr]) -> vim.lsp.get_clients({ bufnr = bufnr })
-- Override the deprecated function to use the new API before plugins load
vim.lsp.buf_get_clients = function(bufnr)
	-- Use the new API: vim.lsp.get_clients() with optional bufnr filter
	-- If bufnr is nil or 0, it defaults to current buffer
	if bufnr and bufnr ~= 0 then
		return vim.lsp.get_clients({ bufnr = bufnr })
	else
		-- When called without args or with 0, get clients for current buffer
		return vim.lsp.get_clients({ bufnr = 0 })
	end
end

vim.api.nvim_create_user_command("RaiseTmuxPane", function()
	-- Get the current tmux pane ID
	local current_pane = vim.fn.environ()["TMUX_PANE"]

	-- If we're not in tmux, notify and exit
	if not current_pane or current_pane == "" then
		vim.notify("Not running inside tmux", vim.log.levels.WARN)
		return
	end

	-- Select the window containing this pane
	vim.fn.system("tmux select-window -t " .. current_pane)

	vim.notify("Raised tmux window", vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command("Nurl", function()
	local url = vim.fn.input("Enter a URL: ")
	local rev = vim.fn.input("Enter the revision (e.g., v0.2.0 or empty string): ")

	-- Check if `nurl` command exists
	if vim.fn.executable("nurl") == 0 then
		vim.notify("The 'nurl' command is not installed or not in PATH", vim.log.levels.ERROR)
		return
	end

	local cmd = string.format("nurl %s %s 2>/dev/null", url, rev)

	local output = vim.fn.systemlist(cmd)
	if vim.v.shell_error == 0 and #output > 0 then
		vim.api.nvim_put(output, "l", true, true)
	else
		vim.notify("Error executing 'nurl' command or command returned empty result.", vim.log.levels.ERROR)
	end
end, {})

require("lazy").setup({
	{
		"AstroNvim/AstroNvim",
		version = "^5",
		import = "astronvim.plugins",
	},

	-- make sure we use the commit from nixpkgs that is compatible with our grammars.
	{
		"nvim-treesitter/nvim-treesitter",
		commit = vim.fn.readfile(vim.fn.stdpath("config") .. "/treesitter-rev", "", 1)[1],
	},
	{ import = "plugins" },
})
