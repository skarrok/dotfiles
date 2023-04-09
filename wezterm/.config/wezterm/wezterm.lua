local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.font = wezterm.font("CaskaydiaCove Nerd Font", {weight="DemiBold", stretch="Normal", style="Normal"})
config.font_size = 13.0
config.enable_tab_bar = false
config.color_scheme = 'Gruvbox light, medium (base16)'
config.color_scheme = 'Gruvbox dark, medium (base16)'
config.window_background_opacity = 0.8

return config
