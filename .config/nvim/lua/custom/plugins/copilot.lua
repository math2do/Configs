return {
	'github/copilot.vim',
	config = function()
		vim.g.copilot_no_tab_map = true
		-- accept full suggestion with Tab
		vim.keymap.set('i', '<Tab>', 'copilot#Accept("\\<Tab>")', {
			expr = true,
			replace_keycodes = false,
			desc = 'Accept Copilot suggestion',
		})
		-- accept word by word
		vim.keymap.set('i', '<C-f>', 'copilot#AcceptWord()', {
			expr = true,
			replace_keycodes = false,
			desc = 'Accept Copilot word',
		})
	end,
}
