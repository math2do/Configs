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
				highlights = {
					border = 'Normal',
					background = 'Normal',
				},
			},
		})

		vim.keymap.set({ 'n', 'i', 'v' }, '<C-\\>', function()
			vim.cmd('write')
			require('toggleterm').toggle()
		end, { noremap = true, silent = true, desc = 'Save & Toggle Terminal' })

		-- Optional: floating terminal for lazygit or similar
		local Terminal = require('toggleterm.terminal').Terminal
		local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })

		function _lazygit_toggle()
			vim.cmd('write')
			lazygit:toggle()
		end

		vim.keymap.set('n', '<leader>gg', _lazygit_toggle, { desc = 'Toggle Lazygit' })
	end,
}
