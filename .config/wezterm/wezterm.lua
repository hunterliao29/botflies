local wezterm = require("wezterm")

local config = wezterm.config_builder()

local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

config.debug_key_events = true
local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

config.keys = {
	-- This will create a new split and run your default program inside it
	{
		key = "RightShift",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
}

config.color_scheme = "Tokyo Night Moon"

config.font = wezterm.font({
	family = "MonoLisa",
	harfbuzz_features = {
		"zero",
		"ss02",
		"ss04",
		"ss08",
		"ss10",
		"ss11",
		"ss12",
		"ss13",
		"ss17",
	},
})

config.font_size = 13

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

config.window_frame = {
	font = wezterm.font({ family = "SF Pro", weight = "Bold" }),
	active_titlebar_bg = "#444a73",
}

config.force_reverse_video_cursor = true

config.term = "wezterm"

config.front_end = "WebGpu"

function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#2f334d"
	local foreground = "#828bb8"
	if tab.is_active then
		background = "#222436"
		foreground = "#c8d3f5"
	end
	local title = tab_title(tab)
	title = wezterm.truncate_right(title, max_width - 2)
	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = " " .. title .. " " },
	}
end)

return config
