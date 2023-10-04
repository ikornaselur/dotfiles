local wezterm = require('wezterm');

local config = {};

if wezterm.config_builder then config = wezterm.config_builder() end

function get_appearance()
    if wezterm.gui then return wezterm.gui.get_appearance() end
    return 'Dark'
end

function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return 'Gruvbox Dark (Gogh)'
    else
        return 'Gruvbox (Gogh)'
    end
end

config.color_scheme = scheme_for_appearance(get_appearance());
config.enable_tab_bar = false;
config.font = wezterm.font("FiraCode Nerd Font");
config.font_size = 14.0;
config.keys = {
    -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
    {
        key = "LeftArrow",
        mods = "OPT",
        action = wezterm.action {SendString = "\x1bb"}
    }, -- Make Option-Right equivalent to Alt-f; forward-word
    {
        key = "RightArrow",
        mods = "OPT",
        action = wezterm.action {SendString = "\x1bf"}
    }
};
config.window_decorations = "RESIZE";
config.window_padding = {left = 0, right = 0, top = 0, bottom = 0};

return config
