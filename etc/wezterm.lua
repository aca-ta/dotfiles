local wezterm = require 'wezterm';

if os.getenv("HOME") then
    -- macos or linux
    prog = {"zsh", "-l"}
else
    -- windows
    prog ={"wsl.exe", "~", "-d", "Ubuntu"}

end
return {
    default_prog = prog,
    font = wezterm.font("Cica", {weight="Regular", stretch="Normal"}),
    font_size = 16.0,
    window_background_opacity = 0.9,
    use_ime = true,
    hide_tab_bar_if_only_one_tab = true
}
