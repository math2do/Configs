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
local lombok_path = vim.fn.expand('~/.local/share/nvim/mason/share/jdtls/lombok.jar')
local mason_path = vim.fn.expand('~/.local/share/nvim/mason')

-- bundles for test and debug
local bundles = {}

local java_debug_bundles = vim.split(
	vim.fn.glob(mason_path .. '/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar'),
	'\n',
	{ trimempty = true }
)
vim.list_extend(bundles, java_debug_bundles)

local java_test_bundles =
	vim.split(vim.fn.glob(mason_path .. '/packages/java-test/extension/server/*.jar'), '\n', { trimempty = true })
vim.list_extend(bundles, java_test_bundles)

local config = {
	cmd = {
		jdtls_path,
		'--jvm-arg=-javaagent:' .. lombok_path, -- lombok agent
		'--jvm-arg=-Xbootclasspath/a:' .. lombok_path,
	},
	root_dir = root_dir,
	init_options = {
		bundles = bundles,
	},
	settings = {
		java = {},
	},
}

jdtls.start_or_attach(config)
jdtls.setup_dap({
	hotcodereplace = 'auto',
	config_overrides = {},
})

vim.api.nvim_set_keymap('n', '<leader>ai', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
