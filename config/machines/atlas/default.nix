{
    pkgs,
    ...
}:
{
    imports = [
        ./hardware.nix
        ../../common-graphical.nix
        ../../nixos/impermanence.nix
    ];

    unfree = [
        "vscode"
        "discord"
        "spotify"
        "vscode-extension-ms-vscode-cpptools"
    ];

    time.timeZone = "Europe/Helsinki";

    networking.networkmanager.enable = true;

    users.users.wux.extraGroups = [
        "networkmanager"
        "dialout"
    ];

    services.upower.enable = true;
    programs.light.enable = true;
    services.playerctld.enable = true;

    home-manager.users.wux = {
        home.packages = with pkgs; [
            status
        ];

        wayland.windowManager.hyprland.settings = {
            monitor = [ ",preferred,auto,1.5" ];

            input = {
                kb_layout = "fi";
                touchpad = {
                    disable_while_typing = false;
                    natural_scroll = true;
                    scroll_factor = 0.5;
                };
            };

            gesture = [
                "3, horizontal, workspace"
            ];
            gestures = {
                workspace_swipe_create_new = false;
                workspace_swipe_forever = true;
            };

            misc.vfr = true;

            animations.enabled = false;
            decoration.blur.enabled = false;
        };

        services.hyprpaper.settings =
            let
                wp_1 = toString pkgs.wallpaper.cute-fox;
            in
            {
                preload = [ wp_1 ];
                wallpaper = [
                    "eDP-1,${wp_1}"
                ];
            };
    };

    system.stateVersion = "25.11";
}
