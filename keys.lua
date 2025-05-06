local keys = {}

function keys:init(wezterm, act, resurrect, workspace_switcher)
	local _keys = {
		{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
		{ key = "l", mods = "CMD|SHIFT", action = act.ActivateTabRelative(1) },
		{ key = "h", mods = "CMD|SHIFT", action = act.ActivateTabRelative(-1) },
		{ key = "j", mods = "CMD", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "CMD", action = act.ActivatePaneDirection("Up") },
		{ key = "Enter", mods = "CMD", action = act.ActivateCopyMode },
		{ key = "R", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
		{ key = "+", mods = "CTRL", action = act.IncreaseFontSize },
		{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
		{ key = "0", mods = "CTRL", action = act.ResetFontSize },
		{ key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
		{ key = "N", mods = "SHIFT|CTRL", action = act.SpawnWindow },
		{ key = "PageUp", mods = "CTRL", action = act.ActivateTabRelative(-1) },
		{ key = "PageDown", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "LeftArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Left") },
		{ key = "RightArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Right") },
		{ key = "UpArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Up") },
		{ key = "DownArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Down") },
		{ key = "f", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "d", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },
		{ key = "x", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },
		{ key = "b", mods = "LEADER|CTRL", action = act.SendString("\x02") },
		{
			key = "w",
			mods = "ALT",
			action = wezterm.action_callback(function(win, pane)
				resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
			end),
		},
		{
			key = "W",
			mods = "ALT",
			action = resurrect.window_state.save_window_action(),
		},
		{
			key = "T",
			mods = "ALT",
			action = resurrect.tab_state.save_tab_action(),
		},
		{
			key = "s",
			mods = "ALT",
			action = wezterm.action_callback(function(win, pane)
				resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
				resurrect.window_state.save_window_action()
			end),
		},
		{
			key = "r",
			mods = "ALT",
			action = wezterm.action_callback(function(win, pane)
				resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
					local type = string.match(id, "^([^/]+)") -- match before '/'
					id = string.match(id, "([^/]+)$") -- match after '/'
					id = string.match(id, "(.+)%..+$") -- remove file extention
					local opts = {
						relative = true,
						restore_text = true,
						on_pane_restore = resurrect.tab_state.default_on_pane_restore,
					}
					if type == "workspace" then
						local state = resurrect.state_manager.load_state(id, "workspace")
						resurrect.workspace_state.restore_workspace(state, opts)
					elseif type == "window" then
						local state = resurrect.state_manager.load_state(id, "window")
						resurrect.window_state.restore_window(pane:window(), state, opts)
					elseif type == "tab" then
						local state = resurrect.state_manager.load_state(id, "tab")
						resurrect.tab_state.restore_tab(pane:tab(), state, opts)
					end
				end)
			end),
		},
		{
			key = "s",
			mods = "LEADER",
			action = workspace_switcher.switch_workspace(),
		},
		{
			key = "S",
			mods = "LEADER",
			action = workspace_switcher.switch_to_prev_workspace(),
		},
		{
			key = "d",
			mods = "ALT",
			action = wezterm.action_callback(function(win, pane)
				resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
					resurrect.state_manager.delete_state(id)
				end, {
					title = "Delete State",
					description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
					fuzzy_description = "Search State to Delete: ",
					is_fuzzy = true,
				})
			end),
		},
	}
	return _keys
end

return keys
