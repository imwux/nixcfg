{ pkgs, lib, ... }:
{
    imports = [
        ./hardware.nix
        ../../common-graphical.nix
        ../../nixos/impermanence.nix
    ];

    unfree = [
        "steam"
        "steam-unwrapped"
        "discord"
        "spotify"
        "vscode"
        "vscode-extension-ms-vscode-cpptools"
        "claude-code"
    ];

    time.timeZone = "Europe/Helsinki";

    networking.networkmanager.enable = true;

    users.users.wux.extraGroups = [
        "networkmanager"
        "wireshark"
    ];

    virtualisation.libvirtd = {
        enable = true;
        qemu = {
            package = pkgs.qemu_kvm;
            swtpm.enable = true;
        };
    };
    virtualisation.virtualbox.host.enable = true;

    programs.steam.enable = true;

    programs.wireshark = {
        enable = true;
        package = pkgs.wireshark;
    };

    home-manager.users.wux = {
        home.packages = with pkgs; [
            vesktop
            prismlauncher

            unstable.freecad
            unstable.kicad
            unstable.orca-slicer

            solaar

            claude-code
        ];

        wayland.windowManager.hyprland.settings = {
            config = {
                input = {
                    kb_layout = "fi";
                    sensitivity = -1.7;
                };
                general.layout = "master";
            };

            workspace_rule = [
                {
                    workspace = "1";
                    monitor = "DP-2";
                    default = true;
                }
                {
                    workspace = "special:special";
                    monitor = "DP-2";
                    layout = "master";
                    layout_opts = {
                        orientation = "center";
                    };
                }
                {
                    workspace = "name:second_monitor";
                    monitor = "HDMI-A-1";
                    default = true;
                    layout = "dwindle";
                }
            ]
            ++ map (num: {
                workspace = toString num;
                monitor = "DP-2";
            }) (lib.range 0 9);

            bind = [
                {
                    _args = [
                        (lib.generators.mkLuaInline "mod_key .. \" + R\"")
                        (lib.generators.mkLuaInline ''
                            function()
                                if hl.get_active_workspace().tiled_layout ~= "master" then
                                    return
                                end

                                hl.dispatch(hl.dsp.layout("swapwithmaster ignoremaster"))

                                local orientation = hl.get_config("master.orientation")
                                if orientation == "right" then
                                    hl.dispatch(hl.dsp.layout("mfact exact 0.75"))
                                else
                                    hl.dispatch(hl.dsp.layout("mfact exact 0.5"))
                                end
                            end
                        '')
                    ];
                }
                {
                    _args = [
                        (lib.generators.mkLuaInline "mod_key .. \" + T\"")
                        (lib.generators.mkLuaInline ''
                            function()
                                if hl.get_active_workspace().tiled_layout ~= "master" then
                                    return
                                end

                                local orientation = hl.get_config("master.orientation")
                                if orientation == "right" then
                                    hl.notification.create({ text = "Center Layout", timeout = 5000, color = "0xFF0394fc" })
                                    hl.dispatch(hl.dsp.layout("orientationcenter"))
                                    hl.dispatch(hl.dsp.layout("mfact exact 0.5"))
                                    hl.config({ master = { orientation = "center" }})
                                else
                                    hl.notification.create({ text = "Right Layout", timeout = 5000, color = "0xFF0394fc" })
                                    hl.dispatch(hl.dsp.layout("orientationright"))
                                    hl.dispatch(hl.dsp.layout("mfact exact 0.75"))
                                    hl.config({ master = { orientation = "right" }})
                                end
                            end
                        '')
                    ];
                }
            ];

            monitor = [
                {
                    output = "DP-2";
                    mode = "3840x1080@144";
                    position = "0x1080";
                    scale = 1;
                }
                {
                    output = "HDMI-A-1";
                    mode = "1920x1080";
                    position = "1280x0";
                    scale = 1;
                }
            ];
        };

        services.hyprpaper.settings = {
            wallpaper = [
                {
                    monitor = "DP-2";
                    path = toString pkgs.wallpaper."3840x1080-lion-king";
                }
                {
                    monitor = "HDMI-A-1";
                    path = toString pkgs.wallpaper."elysium-dark-1920x1080";
                }
            ];
        };
    };

    system.stateVersion = "25.05";
}
