-- Central list of plugin module imports. Lazy will pull in each file referenced here.
return {
	{ import = "plugins.core" },
	{ import = "plugins.tooling" },
	{ import = "plugins.languages" },
	-- Additional groups get appended here (completion, lsp, languages, etc.).
}
