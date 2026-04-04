-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
	'nvim-neo-tree/neo-tree.nvim',
	version = '*',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
		'MunifTanjim/nui.nvim',
	},
	lazy = false,
	keys = {
		{ '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
	},
	opts = {
		filesystem = {
			window = {
				mappings = {
					['\\'] = 'close_window',
				},
			},
			filtered_items = {
				visible = true, -- 👈 Show all files, even hidden ones
				show_hidden_count = true,
				hide_dotfiles = false, -- 👈 Don't hide dotfiles (e.g., .git, .env)
				hide_gitignored = false, -- 👈 Don't hide files in .gitignore
			},
		},
	},
}
