{ inputs, system, pkgs, ... }: {
    imports = [
        ./hardware.nix
        ../../common-graphical.nix
    ];

    systemd.mounts = [{
        description = "Mount balder";
        what = "/dev/disk/by-label/balder";
        where = "/run/balder";
        type = "ext4";
        options = "nofail,user";
    }];

    systemd.automounts = [{
        description = "Automount for balder";
        where = "/run/balder";
        wantedBy = [ "multi-user.target" ];
    }];

    time.timeZone = "Europe/Helsinki";

    networking.networkmanager.enable = true;
    users.users.wux.extraGroups = [ "networkmanager" ];

    unfree = [ "vscode" "discord" "spotify" "vscode-extension-ms-vscode-cpptools" ];

    services.xserver.videoDrivers = [ "nvidia" ];

    services.upower.enable = true;

    programs.light.enable = true;

    services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils-full}/bin/chgrp video /sys/class/backlight/%k/brightness"
        ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils-full}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';

    services.playerctld.enable = true;

    home-manager.users.wux = {
        wayland.windowManager.hyprland.settings = {
            exec-once = [ "${inputs.wuxs-ui.packages.${system}.default}/bin/wuxs-ui" ];

            monitor = [ ",preferred,auto,2" ];

            input.kb_layout = "fi";

            animations.enabled = false;
            decoration.blur.enabled = false;
        };

        services.hyprpaper.settings = let wp_1 = toString pkgs.wallpaper.landscape-cloudy-mountain; in {
            preload = [wp_1];
            wallpaper = [
                "eDP-1,${wp_1}"
            ];
        };
    };
}
