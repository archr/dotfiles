local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback {
  'JetBrains Mono',
  'Menlo',
}
config.font_size = 14
config.line_height = 1.08

config.color_scheme = 'Apple System Colors'

config.window_decorations = 'RESIZE'
config.window_background_opacity = 0.94
config.macos_window_background_blur = 24
config.window_padding = {
  left = 14,
  right = 14,
  top = 12,
  bottom = 12,
}

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.scrollback_lines = 10000
config.audible_bell = 'Disabled'

-- Ctrl+click abre links. Arrancamos de los bindings por defecto para no
-- perder seleccion, copiado, etc.
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  -- Sin esto, el Down de Ctrl+click igual llega al programa (vim, tmux) y
  -- ademas arranca una seleccion.
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.Nop,
  },
}

-- Ademas de las reglas por defecto (http/https/mailto), detecta dominios
-- escritos sin esquema, tipo www.wezterm.org o github.com/wez/wezterm.
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  regex = [[\bwww\.[\w.-]+\.[a-z]{2,15}\S*\b]],
  format = 'https://$0',
})

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  {
    key = 'a',
    mods = 'LEADER|CTRL',
    action = act.SendKey { key = 'a', mods = 'CTRL' },
  },
}

return config
