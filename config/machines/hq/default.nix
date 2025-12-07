{ pkgs, ... }:
{
    imports = [
        ./hardware.nix
        ../../common-graphical.nix
        ../../nixos/impermanence.nix
    ];

    time.timeZone = "Europe/Helsinki";

    networking.networkmanager.enable = true;
    users.users.wux.extraGroups = [ "networkmanager" ];

    unfree = [
        "steam"
        "steam-unwrapped"
        "discord"
        "vscode"
        "discord"
        "spotify"
        "vscode-extension-ms-vscode-cpptools"
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

    environment.systemPackages = with pkgs; [ android-tools ];

    home-manager.users.wux = {
        home.packages = with pkgs; [
            prismlauncher
            wasistlos

            freecad
            unstable.kicad
            unstable.orca-slicer
        ];

        wayland.windowManager.hyprland.settings = {
            input = {
                kb_layout = "fi";
                sensitivity = -0.85;
            };
            monitor = [
                "DP-2, 3840x1080@144, 0x1080, 1"
                "HDMI-A-1, 1920x1080, 1280x0, 1"
            ];
        };

        services.hyprpaper.settings =
            let
                # wp_1 = toString pkgs.wallpaper."3840x1080-lion-king";
                wp_1 = toString pkgs.wallpaper."elysium-dark-3840x1080";
                wp_2 = toString pkgs.wallpaper."elysium-dark-1920x1080";
            in
            {
                preload = [
                    wp_1
                    wp_2
                ];
                wallpaper = [
                    "DP-2,${wp_1}"
                    "HDMI-A-1,${wp_2}"
                ];
            };
    };

    system.stateVersion = "25.05";
}
