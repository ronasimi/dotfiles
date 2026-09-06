-- Guard the plugin configuration to prevent startup errors if uninitialized
if hl.plugin.hymission ~= nil then
    hl.config({
        plugin = {
            hymission = {
                -- Layout: Common Geometry and Sizing
                outer_padding = 32,
                outer_padding_top = 72,
                outer_padding_right = 72,
                outer_padding_bottom = 72,
                outer_padding_left = 72,
                row_spacing = 36,
                column_spacing = 36,
                min_window_length = 120,
                min_preview_short_edge = 32,
                small_window_boost = 1.35,
                max_preview_scale = 0.95,
                workspace_overview_max_preview_scale = 0.95,
                min_slot_scale = 0.10,
                one_workspace_per_row = 0,

                -- Layout: Engine Selection
                layout_engine = "grid",
                layout_engine_forceall = "",
                layout_engine_all = "",
                layout_engine_onlycurrentworkspace = "",
                layout_scale_weight = 1.0,
                layout_space_weight = 0.10,
                natural_scale_flex = 0.22,

                -- Behavior: Workspace Scope and Transitions
                multi_workspace_sort_recent_first = 1,
                only_active_workspace = 0,
                only_active_monitor = 0,
                show_special = 0,
                workspace_change_keeps_overview = 1,

                -- Behavior: Hover and Selection
                selected_expand_scale = 1.18,
                hover_expand_scale = 1.18,
                overview_focus_follows_mouse = 1,
                show_focus_indicator = 0,

                -- Grouped Windows
                grouped_windows_policy = "expanded",
                grouped_windows_collapsed_labels = 1,
                grouped_windows_collapsed_scroll = 1,

                -- Keyboard Navigation
                vim_keys = 0,

                -- Toggle Switch and Gestures
                toggle_switch_mode = 1,
                switch_toggle_auto_next = 1,
                switch_release_key = "Super_L",
                gesture_invert_vertical = 0,

                -- Animation: Hover Relayout
                hover_relayout_animation = "",
                hover_relayout_duration = 140,
                hover_relayout_curve = "ease_out_cubic",

                -- Niri Mode
                niri_mode = 0,
                niri_scroll_pixels_per_delta = 1.0,
                niri_workspace_scale = 1.0,
                niri_scrolling_preview_gap = 0,

                -- Label Picking
                pick_labels_enabled = 1,
                pick_labels_show = 0,
                pick_labels_mode = "sequential",
                pick_labels_direct_activate = 0,

                -- Window Decorations and Controls
                window_decoration_enabled = 1,
                close_button_enabled = 0,
                close_button_size = 18,
                close_button_inset = 0,

                -- Workspace Strip Behavior and Geometry
                workspace_strip_anchor = "left",
                workspace_strip_empty_mode = "existing",
                workspace_strip_force_show = 0,
                workspace_strip_thickness = 160,
                workspace_strip_gap = 24,
                workspace_strip_refresh_ms = 500,

                -- Bar Integration
                hide_bar_when_strip = 1,
                hide_hyprbars_during_overview = 0,
                hide_hyprglass_during_overview = 1,
                bar_single_mission_control = 0,

                -- Bar Handoff Animation
                hide_bar_animation = 1,
                hide_bar_animation_blur = 1,
                hide_bar_animation_move_multiplier = 0.8,
                hide_bar_animation_scale_divisor = 1.1,
                hide_bar_animation_alpha_end = 0.0,

                -- General Appearance
                backdrop_blur = 1,
                backdrop_color = "rgba(00000033)",
                focus_hover_thickness = 2,
                focus_selected_thickness = 4,
                focus_hover_color = "rgba(f2f7ff8c)",
                focus_selected_color = "rgba(3dc7fff2)",
                focus_title_color = "rgba(ffffffff)",

                -- Window Controls and Label Chips Colors
                close_button_color = "rgba(29292eeb)",
                close_button_hover_color = "rgba(f24d47f2)",
                close_button_glyph_color = "rgba(fffffffa)",

                -- Workspace Strip Colors
                workspace_strip_background_color = "rgba(0812243d)",
                workspace_strip_inactive_color = "rgba(0d17262e)",
                workspace_strip_active_color = "rgba(1a2e523d)",
                workspace_strip_empty_color = "rgba(0f1a292e)",
                workspace_strip_new_color = "rgba(1c293b42)",
                workspace_strip_hover_tint_color = "rgba(ffffff0f)",
                workspace_strip_active_tint_color = "rgba(5794f21a)",
                workspace_strip_inactive_tint_color = "rgba(00000000)",
                workspace_strip_plus_color = "rgba(f7fbffe0)",

                -- Debug Options
                debug_logs = 0,
                debug_surface_logs = 0,
            }
        }
    })
end

-- Guard and configure hyprgrass
if hl.plugin.hyprgrass ~= nil then
    hl.config({
        plugin = {
            hyprgrass = {
                -- Touch sensitivity scale factor
                sensitivity = 1.0,

                -- Long press delay in milliseconds
                long_press_delay = 400,

                -- Resize windows by long-pressing on window borders and gaps
                resize_on_border_long_press = true,

                -- Edge margin in pixels for edge-swipe gestures
                edge_margin = 10,
            }
        }
    })
end
