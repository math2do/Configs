return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				-- theme = 'dracula', -- some text are not appearing with this theme
				icons_enabled = true,
			},
		})
	end,
}

