-- Guard the plugin configuration to prevent startup errors if uninitialized
if hl.plugin.hymission ~= nil then
    hl.config({
        plugin = {
            hymission = {
                -- Your specific overrides
                outer_padding_top = 72,
                outer_padding_right = 72,
                outer_padding_bottom = 72,
                outer_padding_left = 72,
                row_spacing = 36,
                column_spacing = 36,
                max_preview_scale = 0.95,
                toggle_switch_mode = 1,
                switch_toggle_auto_next = 1,
                switch_release_key = "Super_L",

                -- Layout Defaults
                min_window_length = 120,
                min_preview_short_edge = 32,
                small_window_boost = 1.35,
                workspace_overview_max_preview_scale = 0.95,
                min_slot_scale = 0.10,
                natural_scale_flex = 0.22,
                layout_scale_weight = 1.0,
                layout_space_weight = 0.10,
                one_workspace_per_row = 0,

                -- Behavior Defaults
                expand_selected_window = 1,
                overview_focus_follows_mouse = 1,

                -- Appearance Defaults
                backdrop_color = "rgba(00000033)",
                backdrop_blur = 1,
                focus_hover_color = "rgba(f2f7ff8c)",
                focus_selected_color = "rgba(3dc7fff2)",
                focus_title_color = "rgba(ffffffff)",
                focus_hover_thickness = 2,
                focus_selected_thickness = 4,
                drag_preview_color = "rgba(29333d47)",
                drag_outline_color = "rgba(f2f7ffd1)",
                drag_outline_thickness = 2,
                close_button_color = "rgba(29292eeb)",
                close_button_hover_color = "rgba(f24d47f2)",
                close_button_glyph_color = "rgba(fffffffa)",
            }
        },
        plugin = {
            hyprgrass = {
                -- The default sensitivity is probably too low on tablet screens,
                -- I recommend turning it up to 4.0
                sensitivity = 1.0,

                -- in milliseconds
                long_press_delay = 400,

                -- resize windows by long-pressing on window borders and gaps.
                -- If general:resize_on_border is enabled, general:extend_border_grab_area is
                -- used for floating windows
                resize_on_border_long_press = true,

                -- in pixels, the distance from the edge that is considered an edge
                edge_margin = 10,
            }
        }
    })
end

