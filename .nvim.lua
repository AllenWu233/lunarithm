require("blink.cmp").setup({
	sources = {
		default = { "path" },
		providers = {
			path = {
				opts = {
					cwd = vim.fn.getcwd() .. "/static/images",
				},
			},
		},
	},
})
