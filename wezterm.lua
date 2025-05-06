-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local barConfig = require("bar-wezterm")
local resConfig = require("resurrectConfig")
local keyConfig = require("keys")
-- Plugins
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
resurrect.state_manager.change_state_save_dir("C:\\Users\\\\Davin\\.config\\state")

local config = {}
local mouse_bindings = {}
local launch_menu = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font Mono",
	"SpaceMono Nerd Font",
})
config.font_size = 9
config.launch_menu = launch_menu
-- makes my cursor blink
config.default_cursor_style = "BlinkingBar"
config.disable_default_key_bindings = true
-- Needed for tabline.wez
config.use_fancy_tab_bar = false
-- Add's + Button Next To Tabs
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32
-- Disables Windows Controls
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
--
config.status_update_interval = 250

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font({ family = "JetBrainsMono Nerd Font Mono", weight = "Bold" }),

	-- The size of the font in the tab bar.
	-- Default to 10.0 on Windows but 12.0 on other systems
	font_size = 7.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "#585b70",

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = "#313244",
}

config.colors = {
	tab_bar = {
		background = "#1e1e2e",
		active_tab = {
			bg_color = "#585b70",
			fg_color = "#a6adc8",
		},
		inactive_tab = {
			bg_color = "#313244",
			fg_color = "#a6adc8",
		},
		-- The color of the inactive tab bar edge/divider
		inactive_tab_edge = "#9399b2",
	},
}

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

config.window_background_opacity = 0.90
-- Change the color scheme
config.color_scheme = "Catppuccin Mocha"
config.use_dead_keys = false -- Disable Dead Keys
config.scrollback_lines = 5000
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = false
config.disable_default_key_bindings = true -- Disable Default Keybinds

-- There are mouse binding to mimc Windows Terminal and let you copy
-- To copy just highlight something and right click. Simple
mouse_bindings = {
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
	},
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
			end
		end),
	},
}
config.mouse_bindings = mouse_bindings

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = keyConfig:init(wezterm, act, resurrect, workspace_switcher)

barConfig:init(wezterm, config, bar)
resConfig:init(wezterm, workspace_switcher, resurrect)
--tabConfig:init(wezterm, tabline, config)
-- Set to pwsh instead of cmd
config.default_prog = { "pwsh.exe" }

smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)
	-- if you want to use separate direction keys for move vs. resize, you
	-- can also do this:
	direction_keys = {
		move = { "h", "j", "k", "l" },
		resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
	},
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
	-- log level to use: info, warn, error
	log_level = "info",
})
workspace_switcher.apply_to_config(config)
wezterm.plugin.update_all()
-- and finally, return the configuration to wezterm
return config
