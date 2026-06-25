{
    pkgs,
    lib,
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
        "claude-code"
    ];

    time.timeZone = "Europe/Helsinki";

    networking.networkmanager.enable = true;

    users.users.wux.extraGroups = [
        "networkmanager"
        "dialout"
    ];

    services.upower.enable = true;
    services.playerctld.enable = true;

    home-manager.users.wux = {
        home.packages = with pkgs; [
            vesktop

            claude-code

            status
        ];

        wayland.windowManager.hyprland.settings = {
            config = {
                input = {
                    kb_layout = "fi";
                    touchpad = {
                        disable_while_typing = false;
                        natural_scroll = true;
                        scroll_factor = 0.5;
                    };
                };

                gestures = {
                    workspace_swipe_create_new = false;
                    workspace_swipe_forever = true;
                };

                animations.enabled = false;
                decoration.blur.enabled = lib.mkForce false;
            };

            monitor = [
                {
                    output = "";
                    mode = "preferred";
                    position = "auto";
                    scale = 1.5;
                }
            ];

            gesture = [
                {
                    fingers = 3;
                    direction = "horizontal";
                    action = "workspace";
                }
            ];
        };

        services.hyprpaper.settings = {
            wallpaper = [
                {
                    monitor = "eDP-1";
                    path = toString pkgs.wallpaper.cute-fox;
                }
            ];
        };
    };

    system.stateVersion = "25.11";
}
