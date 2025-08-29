{ lib, config, pkgs, ... }:
lib.mkIf config.wayland.windowManager.hyprland.enable {
    home.packages = with pkgs; [ cliphist wl-clipboard material-symbols lexend ];

    wayland.windowManager.hyprland = {
        systemd.enable = false;

        settings = {
            exec-once = [
                "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store"
                "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store"
            ];

            input.touchpad.disable_while_typing = false;

            general = {
                "gaps_in" = 0;
                "gaps_out" = 0;
                "col.active_border" = "0xFF308FD9";
            };

            decoration = {
                rounding = 0;
                shadow.enabled = false;
                blur = {
                    new_optimizations = true;
                    special = false;
                    size = 10;
                    passes = 3;
                    brightness = 1;
                    noise = 0.01;
                    contrast = 1.4;
                    popups = true;
                    popups_ignorealpha = 0.6;
                };
            };

            blurls = [ "popup_window" ];
            layerrule = [
                "ignorezero, popup_window"
                "blurpopups, popup_window"
                "blur, bar"
                "blurpopups, bar"
                "ignorezero, bar"
            ];

            windowrulev2 = [
                "opacity 0.95 0.95,class:^(code)$"
                "noblur, class:^(?!(code))"
            ];

            misc.disable_hyprland_logo = true;

            "$mod" = "SUPER";
            bind = [
                "$mod, Return, exec, ${pkgs.alacritty}/bin/alacritty"
                "$mod, D, exec, ${pkgs.bemenu}/bin/bemenu-run"
                "$mod SHIFT, S, exec, ${pkgs.screenshot}/bin/screenshot"
                "$mod, L, exec, ${pkgs.hyprlock}/bin/hyprlock"

                "$mod, V, exec, ${pkgs.cliphist}/bin/cliphist list | bemenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"

                "$mod, F, fullscreenstate, -1, 2"
                "$mod SHIFT, F, fullscreenstate, 2, 2"

                "$mod, R, submap, resize"
                "$mod SHIFT, Q, killactive"

                "$mod, TAB, togglespecialworkspace"
                "$mod SHIFT, TAB, movetoworkspace, special"

                "$mod, SPACE, togglefloating"
                "$mod SHIFT, SPACE, pin"

                "$mod, LEFT, movewindow, l"
                "$mod, RIGHT, movewindow, r"
                "$mod, UP, movewindow, u"
                "$mod, DOWN, movewindow, d"
            ] ++ (
                builtins.concatLists (builtins.genList (ws: [
                    "$mod, ${toString ws}, workspace, ${toString ws}"
                    "$mod SHIFT, ${toString ws}, movetoworkspace, ${toString ws}"
                    "$mod SHIFT ALT, ${toString ws}, movetoworkspacesilent, ${toString ws}"
                ]) 10)
            );
            bindm = [
                "$mod, mouse:272, movewindow"
                "$mod, mouse:273, resizewindow"
                "$mod SHIFT, mouse:272, resizewindow"
                "$mod SHIFT, mouse:273, resizewindow"
            ];
            bindl = [
                ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
                ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
                ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
                ", XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
                ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ];
            bindle = [
                ", XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 5"
                ", XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 5"
                ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ];
        };
        extraConfig = ''
            submap = resize
            binde = , RIGHT, resizeactive, 50 0
            binde = , UP, resizeactive, 0 50
            binde = , LEFT, resizeactive, -50 0
            binde = , DOWN, resizeactive, 0 -50
            bind = , ESCAPE, submap, reset
            submap = reset
        '';
    };

    services.hyprpaper.settings.splash = false;

    programs.hyprlock.settings = {
        background = {
            monitor = "";
            path = "screenshot";
            color = "rgba(25, 20, 20, 1.0)";
            blur_passes = "2";
        };

        input-field = {
            monitor = "";

            halign = "center";
            valign = "center";
            size = "800, 100";
            dots_size = 0.4;

            fade_on_empty = true;
            fade_timeout = 400;
            fail_timeout = 500;

            rounding = 10;
            outline_thickness = 0;

            placeholder_text = "";
            fail_text = "";

            font_color = "rgb(200, 200, 200)";
            inner_color = "rgba(0, 0, 0, 0)";
            outer_color = "rgba(0, 0, 0, 0)";
            check_color = "rgba(28, 240, 255, 0.4)";
            fail_color = "rgba(255, 51, 51, 0.4)";
        };
    };

    xdg.configFile."cliphist/config".text = ''
        max-items 500
        max-dedupe-search 250
    '';

    xdg.configFile."hypr/xdph.conf".text = ''
        screencopy {
            allow_token_by_default = true
            max_fps = 144
        }
    '';
}
