-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font_size = 15

config.enable_tab_bar = false

config.font = wezterm.font("MesloLGS Nerd Font Mono")

config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}


config.keys = {
    -- Option + Left → Backward word
    {
      key = "LeftArrow",
      mods = "OPT",
      action = wezterm.action.SendKey {
        key = "b",
        mods = "ALT",
      },
    },
    -- Option + Right → Forward word
    {
      key = "RightArrow",
      mods = "OPT",
      action = wezterm.action.SendKey {
        key = "f",
        mods = "ALT",
      },
    },
    -- Cmd + Left → Beginning of line
    {
      key = "LeftArrow",
      mods = "CMD",
      action = wezterm.action.SendKey {
        key = "a",
        mods = "CTRL",
      },
    },
    -- Cmd + Right → End of line
    {
      key = "RightArrow",
      mods = "CMD",
      action = wezterm.action.SendKey {
        key = "e",
        mods = "CTRL",
      },
    },
  }

return config