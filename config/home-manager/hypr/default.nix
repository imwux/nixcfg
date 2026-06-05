{
    lib,
    config,
    pkgs,
    ...
}:
lib.mkIf config.wayland.windowManager.hyprland.enable {
    home.packages = with pkgs; [
        wl-clipboard
        cliphist
    ];

    wayland.windowManager.hyprland = {
        configType = "lua";

        systemd.enable = false;

        extraConfig = builtins.readFile ./config.lua;

        settings =
            let
                wobsock = "$XDG_RUNTIME_DIR/wob.sock";
            in
            {
                mod_key._var = "SUPER";

                commands._var = {
                    media = {
                        play_pause = "${pkgs.playerctl}/bin/playerctl play-pause";
                        previous = "${pkgs.playerctl}/bin/playerctl previous";
                        next = "${pkgs.playerctl}/bin/playerctl next";
                    };

                    audio = {
                        raise_volume = "
                            ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
                            ${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed 's/[^0-9]//g' > ${wobsock}
                        ";
                        lower_volume = "
                            ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
                            ${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed 's/[^0-9]//g' > ${wobsock}
                        ";
                        toggle_mic_mute = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
                        toggle_mute = "
                            ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
                            (${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo \"0 muted\" > ${wobsock}) || ${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed 's/[^0-9]//g' > ${wobsock}
                        ";
                    };

                    brightness = {
                        up = "
                            ${pkgs.brightnessctl}/bin/brightnessctl s +5%
                            echo $(( $(${pkgs.brightnessctl}/bin/brightnessctl g) * 100 / $(${pkgs.brightnessctl}/bin/brightnessctl m) )) > ${wobsock}
                        ";
                        down = "
                            ${pkgs.brightnessctl}/bin/brightnessctl s 5%-
                            echo $(( $(${pkgs.brightnessctl}/bin/brightnessctl g) * 100 / $(${pkgs.brightnessctl}/bin/brightnessctl m) )) > ${wobsock}
                        ";
                    };

                    new_terminal = "${pkgs.alacritty}/bin/alacritty";
                    run = "${pkgs.bemenu}/bin/bemenu-run";
                    screenshot = "${pkgs.screenshot}/bin/screenshot";
                    lockscreen = "${pkgs.screenshot}/bin/hyprlock";
                    clipboardhistory = "${pkgs.cliphist}/bin/cliphist list | bemenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy";
                };

                config = {
                    general = {
                        layout = lib.mkDefault "dwindle";
                        gaps_in = 0;
                        gaps_out = 0;
                        "col.active_border" = "0xFF308FD9";
                    };

                    master = {
                        orientation = "center";
                        slave_count_for_center_master = 0;
                        mfact = 0.5;
                    };

                    decoration = {
                        rounding = 0;
                        shadow.enabled = false;
                        blur = {
                            enabled = true;
                            new_optimizations = true;
                            special = false;
                            size = 6;
                            passes = 3;
                            brightness = 1;
                            noise = 0.01;
                            contrast = 1.4;
                            popups = true;
                            popups_ignorealpha = 0.6;
                        };
                    };

                    misc.disable_hyprland_logo = true;

                    input.touchpad.disable_while_typing = false;

                };
            };
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
