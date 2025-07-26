return {
	'akinsho/toggleterm.nvim',
	version = '*',
	config = function()
		require('toggleterm').setup({
			size = 10,
			open_mapping = [[<C-\>]],
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			persist_size = true,
			direction = 'float',
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = 'curved',
				winblend = 0,
				width = 180,
				height = 80,
				highlights = {
					border = 'Normal',
					background = 'Normal',
				},
			},
		})

		-- Optional: floating terminal for lazygit or similar
		local Terminal = require('toggleterm.terminal').Terminal
		local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })

		function _lazygit_toggle()
			lazygit:toggle()
		end

		vim.keymap.set('n', '<leader>gg', _lazygit_toggle, { desc = 'Toggle Lazygit' })
	end,
}
