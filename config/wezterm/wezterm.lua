local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font
config.font_size = 13
config.font = wezterm.font_with_fallback({
    "Source Code Pro",
    "Fira Code",
    { family = "Symbols Nerd Font Mono", scale=1.0 },
})

-- Colors
config.color_scheme = 'OneDark (base16)'
-- config.color_scheme = 'rose-pine-moon'

-- Appearance
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.use_fancy_tab_bar = true
config.window_background_opacity = 0.95
config.macos_window_background_blur = 50


-- Miscellaneous
config.max_fps = 120


return config

