local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font
config.font_size = 13
config.font = wezterm.font("Source Code Pro")

-- Colors
config.color_scheme = 'OneDark (base16)'

-- Appearance
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.use_fancy_tab_bar = true


-- Miscellaneous
config.max_fps = 120


return config

