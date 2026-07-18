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

    programs.uwsm.enable = true;

    services.dbus.implementation = "broker";

    programs.hyprland = {
        enable = true;
        withUWSM = true;
        package = pkgs.hyprland;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    services.greetd = {
        enable = true;
        settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session --user-menu --user-menu-min-uid 1000 --asterisks --power-shutdown 'shutdown -P now' --power-reboot 'shutdown -r now'";
    };

    programs.hyprlock.enable = true;
    environment.sessionVariables = {
        NIXOS_OZONE_WL = 1;
        WLR_NO_HARDWARE_CURSORS = 1;
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

    security.pam.services = {
        login.enableGnomeKeyring = true;
        hyprlock.enableGnomeKeyring = true;
        greetd.enableGnomeKeyring = true;
    };

    home-manager.users.wux = {
        home.packages = with pkgs; [
            element-desktop
            spotify

            gimp
            vlc

            nautilus

            gcr
            seahorse

            meld
            sourcegit

            screenshot
            screenrecord

            yubioath-flutter
        ];

        programs.satty = {
            enable = true;
            settings.general = {
                corner-roundness = 4;
                copy-command = "wl-copy";
            };
        };

        systemd.user.sessionVariables = config.home-manager.users.wux.home.sessionVariables;

        wayland.windowManager.hyprland.enable = true;
        programs.hyprlock.enable = true;
        services.hyprpaper.enable = true;
        services.dunst.enable = true;

        services.gnome-keyring = {
            enable = true;
            components = [
                "pkcs11"
                "secrets"
            ];
        };

        services.wob = {
            enable = true;
            settings = {
                "" = {
                    timeout = 2000;
                    orientation = "vertical";
                    height = 400;
                    width = 75;
                };
                "style.muted" = {
                    border_color = "EB4034";
                };
            };
        };

        services.cliphist.enable = true;

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

            gtk4.theme = null;

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
