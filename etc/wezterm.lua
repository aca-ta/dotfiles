local wezterm = require 'wezterm';

return {
    font = wezterm.font("Cica", {weight="Regular", stretch="Normal", italic=false}),
    font_size = 15.0,
    window_background_opacity = 0.9,
    use_ime = true,
    hide_tab_bar_if_only_one_tab = true
}

