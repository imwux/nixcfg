{ config, pkgs, ... }: {
    imports = [
        ./nixos/firefox.nix
    ];

    users.users.wux.extraGroups = [ "video" "audio" ];

    unfree = [ "nvidia-x11" "nvidia-settings" ];

    console = {
        font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
        packages = with pkgs; [ terminus_font ];
        keyMap = "fi";
    };

    fonts.packages = with pkgs; [ dejavu_fonts ];

    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
    environment.sessionVariables = {
        NIXOS_OZONE_WL = 1;
        WLR_NO_HARDWARE_CURSORS = 1;
        NIX_SHELL_PRESERVE_PROMPT = 1;
    };

    qt = {
        enable = true;
        style = "adwaita-dark";
        platformTheme = "gnome";
    };

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };
    nixpkgs.config.pulseaudio = true;

    services.gvfs.enable = true; # Needed for Astal (UI)

    programs.firefox.enable = true;

    home-manager.users.wux = {
        home.packages = with pkgs; [
            spotify
            discord
            gimp
            screenshot
        ];

        wayland.windowManager.hyprland.enable = true;
        programs.hyprlock.enable = true;
        systemd.user.sessionVariables = config.home-manager.users.wux.home.sessionVariables;
        services.hyprpaper.enable = true;
        services.mpris-proxy.enable = true;

        home.pointerCursor = {
            name = "phinger-cursors-dark";
            package = pkgs.phinger-cursors;
            size = 32;
            gtk.enable = true;
        };

        gtk = {
            enable = true;
            theme = {
                name = "adw-gtk3-dark";
                package = pkgs.adw-gtk3;
            };
        };

        programs.bemenu.enable = true;
        programs.alacritty.enable = true;
        programs.vscode.enable = true;
        programs.zed-editor.enable = true;
    };
}
