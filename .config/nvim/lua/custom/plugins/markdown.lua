return {
	'MeanderingProgrammer/render-markdown.nvim',
	version = '*',
	enabled = true,
	dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
	opts = {
		heading = {
			backgrounds = {}, -- disable heading backgrounds
		},
		code = {
			disable_background = true, -- disable code block background
			border = 'none', -- border style for code blocks (e.g., 'single', 'double', 'rounded', 'none')
			highlight_border = false, -- whether to highlight the border of code blocks
		},
	},
}
