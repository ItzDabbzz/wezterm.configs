local _resurrect = {}

function _resurrect:init(wezterm, workspace_switcher, resurrect)
	wezterm.on("augment-command-palette", function(window, pane)
		local workspace_state = resurrect.workspace_state
		return {
			{
				brief = "Window | Workspace: Switch Workspace",
				icon = "md_briefcase_arrow_up_down",
				action = workspace_switcher.switch_workspace(),
			},
			{
				brief = "Window | Workspace: Rename Workspace",
				icon = "md_briefcase_edit",
				action = wezterm.action.PromptInputLine({
					description = "Enter new name for workspace",
					action = wezterm.action_callback(function(window, pane, line)
						if line then
							wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
							resurrect.state_manager.save_state(workspace_state.get_workspace_state())
						end
					end),
				}),
			},
		}
	end)
	-- loads the state whenever I create a new workspace
	wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
		local workspace_state = resurrect.workspace_state

		workspace_state.restore_workspace(resurrect.state_manager.load_state(label, "workspace"), {
			window = window,
			relative = true,
			restore_text = true,
			on_pane_restore = resurrect.tab_state.default_on_pane_restore,
		})
	end)

	-- Saves the state whenever I select a workspace
	wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
		local workspace_state = resurrect.workspace_state
		resurrect.state_manager.save_state(workspace_state.get_workspace_state())
	end)
	wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)
	local resurrect_event_listeners = {
		"resurrect.error",
		"resurrect.state_manager.save_state.finished",
	}
	local is_periodic_save = false
	wezterm.on("resurrect.periodic_save", function()
		is_periodic_save = true
	end)
	for _, event in ipairs(resurrect_event_listeners) do
		wezterm.on(event, function(...)
			if event == "resurrect.state_manager.save_state.finished" and is_periodic_save then
				is_periodic_save = false
				return
			end
			local args = { ... }
			local msg = event
			for _, v in ipairs(args) do
				msg = msg .. " " .. tostring(v)
			end
			wezterm.gui.gui_windows()[1]:toast_notification("Wezterm - resurrect", msg, nil, 4000)
		end)
	end
end

return _resurrect
