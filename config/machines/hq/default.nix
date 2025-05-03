{ pkgs, ... }: {
    imports = [
        ./hardware.nix
        ../../common-graphical.nix
    ];

    time.timeZone = "Europe/Helsinki";

    networking.networkmanager.enable = true;
    users.users.wux.extraGroups = [ "networkmanager" ];

    unfree = [ "steam" "steam-unwrapped" "discord" "vscode" "discord" "spotify" "vscode-extension-ms-vscode-cpptools" ];

    services.xserver.videoDrivers = [ "modesetting" ];

    virtualisation.libvirtd = {
        enable = true;
        qemu = {
            package = pkgs.qemu_kvm;
            ovmf = {
                enable = true;
                packages = [pkgs.OVMFFull.fd];
            };
            swtpm.enable = true;
        };
    };
    virtualisation.virtualbox.host.enable = true;

    programs.steam.enable = true;

    home-manager.users.wux = {
        home.packages = with pkgs; [
            prismlauncher
            whatsapp-for-linux
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

        services.hyprpaper.settings = let wp_1 = toString pkgs.wallpaper."3840x1080-lion-king"; in {
            preload = [wp_1];
            wallpaper = [
                "DP-2,${wp_1}"
            ];
        };
    };
}
