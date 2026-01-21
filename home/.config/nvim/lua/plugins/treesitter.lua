return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	opts = {
		-- tree-sitter CLI is wrapped with cc in PATH, so grammars compile from source
		auto_install = true,
	},
}
