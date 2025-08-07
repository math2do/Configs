local jdtls = require('jdtls')
local jdtls_setup = require('jdtls.setup')

local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
local root_dir = jdtls_setup.find_root(root_markers) or vim.fn.getcwd()
-- local root_dir = jdtls_setup.find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' })

if not root_dir then
	vim.notify('[jdtls] root_dir not found.', vim.log.levels.ERROR)
	return
end

local jdtls_path = vim.fn.expand('~/.local/share/nvim/mason/packages/jdtls/bin/jdtls')

local config = {
	cmd = { jdtls_path },
	root_dir = root_dir,
	settings = {
		java = {},
	},
}

jdtls.start_or_attach(config)

vim.api.nvim_set_keymap('n', '<leader>ai', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
