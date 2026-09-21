--          _____                _____                    _____                    _____                    _____            _____                    _____                    _____
--         /\    \              |\    \                  /\    \                  /\    \                  /\    \          /\    \                  /\    \                  /\    \
--        /::\____\             |:\____\                /::\    \                /::\    \                /::\____\        /::\    \                /::\____\                /::\    \
--       /:::/    /             |::|   |               /::::\    \              /::::\    \              /:::/    /       /::::\    \              /::::|   |               /::::\    \
--      /:::/    /              |::|   |              /::::::\    \            /::::::\    \            /:::/    /       /::::::\    \            /:::::|   |              /::::::\    \
--     /:::/    /               |::|   |             /:::/\:::\    \          /:::/\:::\    \          /:::/    /       /:::/\:::\    \          /::::::|   |             /:::/\:::\    \
--    /:::/____/                |::|   |            /:::/__\:::\    \        /:::/__\:::\    \        /:::/    /       /:::/__\:::\    \        /:::/|::|   |            /:::/  \:::\    \
--   /::::\    \                |::|   |           /::::\   \:::\    \      /::::\   \:::\    \      /:::/    /       /::::\   \:::\    \      /:::/ |::|   |           /:::/    \:::\    \
--  /::::::\    \   _____       |::|___|______    /::::::\   \:::\    \    /::::::\   \:::\    \    /:::/    /       /::::::\   \:::\    \    /:::/  |::|   | _____    /:::/    / \:::\    \
-- /:::/\:::\    \ /\    \      /::::::::\    \  /:::/\:::\   \:::\____\  /:::/\:::\   \:::\____\  /:::/    /       /:::/\:::\   \:::\    \  /:::/   |::|   |/\    \  /:::/    /   \:::\ ___\
-- /:::/  \:::\    /::\____\    /::::::::::\____\/:::/  \:::\   \:::|    |/:::/  \:::\   \:::|    |/:::/____/       /:::/  \:::\   \:::\____\/:: /    |::|   /::\____\/:::/____/     \:::|    |
-- \::/    \:::\  /:::/    /   /:::/~~~~/~~      \::/    \:::\  /:::|____|\::/   |::::\  /:::|____|\:::\    \       \::/    \:::\  /:::/    /\::/    /|::|  /:::/    /\:::\    \     /:::|____|
-- \/____/ \:::\/:::/    /   /:::/    /          \/_____/\:::\/:::/    /  \/____|:::::\/:::/    /  \:::\    \       \/____/ \:::\/:::/    /  \/____/ |::| /:::/    /  \:::\    \   /:::/    /
--          \::::::/    /   /:::/    /                    \::::::/    /         |:::::::::/    /    \:::\    \               \::::::/    /           |::|/:::/    /    \:::\    \ /:::/    /
--           \::::/    /   /:::/    /                      \::::/    /          |::|\::::/    /      \:::\    \               \::::/    /            |::::::/    /      \:::\    /:::/    /
--           /:::/    /    \::/    /                        \::/____/           |::| \::/____/        \:::\    \              /:::/    /             |:::::/    /        \:::\  /:::/    /
--          /:::/    /      \/____/                          ~~                 |::|  ~|               \:::\    \            /:::/    /              |::::/    /          \:::\/:::/    /
--         /:::/    /                                                           |::|   |                \:::\    \          /:::/    /               /:::/    /            \::::::/    /
--        /:::/    /                                                            \::|   |                 \:::\____\        /:::/    /               /:::/    /              \::::/    /
--        \::/    /                                                              \:|   |                  \::/    /        \::/    /                \::/    /                \::/____/
--         \/____/                                                                \|___|                   \/____/          \/____/                  \/____/                  ~~
--
---------------------
----   IMPORTS   ----
---------------------
require("monitors")
require("workspaces")
require("permissions")
__require("functions")
require("rules")
require("animations")
require("keybinds")
require("autostart")
require("plugins")

----------------------------------------
---- GLOBAL CONFIGURATION BATCHING  ----
----------------------------------------
hl.config({
    general    = {
        gaps_in              = 9,
        gaps_out             = { top = 18, left = 18, right = 18, bottom = 18 },
        border_size          = 0,
        col                  = {
            active_border   = "rgba(00000000)",
            inactive_border = "rgba(00000000)",
        },
        resize_on_border     = true,
        hover_icon_on_border = true,
        snap                 = { enabled = true, window_gap = 9, monitor_gap = 9 },
        allow_tearing        = false,
        layout               = "dwindle",
    },
    decoration = {
        rounding         = 9,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 0.95,
        dim_inactive     = false,
        shadow           = {
            enabled        = true,
            range          = 16,
            scale          = 1.0,
            render_power   = 2,
            color          = "rgba(0, 0, 0, 0.25)", -- Exactly 25% opacity
            color_inactive = "rgba(0, 0, 0, 0)",
            offset         = { 0, 0 },
        },
        dim_special      = 0.1,
        blur             = {
            enabled = true,
            size    = 6,
            passes  = 3, -- GPU optimized
            noise   = 0.0234,
            popups  = true,
            special = true
        },
    },
    -- Classic Dwindle spiral: keep new children on the right/bottom, but let
    -- Hyprland choose each split axis dynamically from the parent aspect ratio.
    -- Wide parents split left/right; tall parents split top/bottom. Keeping
    -- preserve_split=false is important here: preserving the previous axis can
    -- collapse a sequence of terminals into repeated top/bottom strips.
    -- precise_mouse_move only affects manual SUPER+drag reinsertion.
    dwindle    = {
        preserve_split               = false,
        force_split                  = 2,
        smart_split                  = false,
        smart_resizing               = true,
        permanent_direction_override = false,
        split_width_multiplier       = 1.0,
        use_active_for_splits        = true,
        default_split_ratio          = 1.0,
        split_bias                   = 0,
        precise_mouse_move           = true,
    },
    master     = { new_status = "master" },
    scrolling  = { fullscreen_on_one_column = true },
    cursor     = { hide_on_key_press = true, sync_gsettings_theme = true },
    binds      = { drag_threshold = 8 },
    misc       = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        focus_on_activate        = true,
        font_family              = "SF Pro",
    },
    input      = {
        kb_layout    = "us",
        follow_mouse = 1,
        sensitivity  = 0.6,
        touchpad     = { natural_scroll = true, drag_lock = 0, scroll_factor = 1.0 },
        touchdevice  = { enabled = true },
    }
})
