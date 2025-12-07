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

    time.timeZone = "Europe/Helsinki";

    networking.networkmanager.enable = true;
    users.users.wux.extraGroups = [
        "networkmanager"
        "dialout"
    ];

    unfree = [
        "vscode"
        "discord"
        "spotify"
        "vscode-extension-ms-vscode-cpptools"
    ];

    services.upower.enable = true;

    programs.light.enable = true;

    services.playerctld.enable = true;

    home-manager.users.wux = {
        wayland.windowManager.hyprland.settings = {
            monitor = [ ",preferred,auto,1.5" ];

            input.kb_layout = "fi";

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
}
