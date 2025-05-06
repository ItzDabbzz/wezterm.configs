local _tabline = {}

function _tabline:init(wezterm, tabline, config)
	_tabline:config(wezterm, tabline, config)
	return true
end

function _tabline:config(wezterm, tabline, config)
	local colors = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
	tabline.setup({
		options = {
			icons_enabled = true,
			theme = "Catppuccin Mocha",
			tabs_enabled = true,
			section_separators = {
				left = wezterm.nerdfonts.pl_left_hard_divider,
				right = wezterm.nerdfonts.pl_right_hard_divider,
			},
			component_separators = {
				left = wezterm.nerdfonts.pl_left_soft_divider,
				right = wezterm.nerdfonts.pl_right_soft_divider,
			},
			tab_separators = {
				left = wezterm.nerdfonts.pl_left_hard_divider,
				right = wezterm.nerdfonts.pl_right_hard_divider,
			},
		},
		sections = {
			tabline_a = { "mode" },
			tabline_b = { "workspace" },
			tabline_c = { " " },
			tab_active = {
				"index",
				{ "parent", padding = 0 },
				"/",
				{ "cwd", padding = { left = 0, right = 1 } },
				{ "zoomed", padding = 0 },
			},
			tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
			tabline_x = { "ram", "cpu" },
			tabline_y = { "datetime", "battery" },
			tabline_z = { "domain" },
		},
	})
	return true
end

return _tabline
