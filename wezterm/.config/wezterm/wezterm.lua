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

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, _)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
end)

wezterm.on('toggle-opacity', function(window, _)
  local default_opacity = 0.8
  local overrides = window:get_config_overrides() or {}
  wezterm.log_error(window:effective_config().window_background_opacity)
  if window:effective_config().window_background_opacity < 1 then
    overrides.window_background_opacity = 1
  else
    overrides.window_background_opacity = default_opacity
  end
  window:set_config_overrides(overrides)
end)

wezterm.on('toggle-color-scheme', function(window, _)
  local light = 'Gruvbox light, medium (base16)'
  local dark = 'Gruvbox dark, medium (base16)'
  local overrides = window:get_config_overrides() or {}
  if window:effective_config().color_scheme == dark then
    overrides.color_scheme = light
  else
    overrides.color_scheme = dark
  end
  window:set_config_overrides(overrides)
end)

config.keys = {
  {
    key = 'o',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateKeyTable {
      name = 'options',
      one_shot = false,
    },
  },
}

config.key_tables = {
    options = {
        { key = 'Escape', action = 'PopKeyTable' },
        { key = 'c', mods = 'CTRL', action = 'PopKeyTable' },

        { key = 't', action = wezterm.action.EmitEvent('toggle-opacity') },
        { key = 'b', action = wezterm.action.EmitEvent('toggle-color-scheme') },
    }
}

return config
