{ config, pkgs, ... }:
{
    imports = [
        ./nixos/firefox.nix
    ];

    users.users.wux.extraGroups = [
        "video"
        "audio"
    ];

    unfree = [
        "nvidia-x11"
        "nvidia-settings"
    ];

    console = {
        font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
        packages = with pkgs; [ terminus_font ];
        keyMap = "fi";
    };

    fonts.packages = with pkgs; [ dejavu_fonts ];

    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = true;
    programs.hyprlock.enable = true;
    environment.sessionVariables = {
        NIXOS_OZONE_WL = 1;
        WLR_NO_HARDWARE_CURSORS = 1;
        NIX_SHELL_PRESERVE_PROMPT = 1;
    };

    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

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

    programs.firefox.enable = true;

    home-manager.users.wux = {
        home.packages = with pkgs; [
            spotify
            discord
            gimp
            vlc

            coppwr
            meld

            screenshot
            screenrecord
        ];

        xdg.configFile."satty/config.toml".source = (pkgs.formats.toml { }).generate "satty.toml" {
            general = {
                corner-roundness = 4;
                copy-command = "wl-copy";
            };
        };

        systemd.user.sessionVariables = config.home-manager.users.wux.home.sessionVariables;

        wayland.windowManager.hyprland.enable = true;
        programs.hyprlock.enable = true;
        services.hyprpaper.enable = true;
        services.dunst.enable = true;

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

            iconTheme = {
                package = pkgs.adwaita-icon-theme;
                name = "Adwaita";
            };
        };

        programs.bemenu.enable = true;
        programs.alacritty.enable = true;
        programs.vscode.enable = true;
        programs.zed-editor.enable = true;
    };
}
