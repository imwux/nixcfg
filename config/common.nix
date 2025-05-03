{ pkgs, ... }: {
    imports = [
        ./nixos/unfree.nix
    ];

    nix = {
        settings = {
            experimental-features = [ "nix-command" "flakes" ];
            trusted-users = [ "root" "wux" ];
        };

        gc = {
            automatic = true;
            persistent = true;
            dates = "48hr";
            randomizedDelaySec = "10min";
        };
    };

    users.users.wux = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
    };

    i18n.defaultLocale = "en_US.UTF-8";

    security = {
        sudo.wheelNeedsPassword = false;
        polkit.enable = true;
        rtkit.enable = true;

        pam.loginLimits = [
            { domain = "@wheel"; item = "nofile"; type = "soft"; value = "524288"; }
            { domain = "@wheel"; item = "nofile"; type = "hard"; value = "1048576"; }
        ];
    };

    programs.nano.enable = false;

    programs.git = {
        enable = true;
        lfs.enable = true;
    };

    environment.variables = {
        GOPATH = "$HOME/.config/go";
        GOMODCACHE = "$HOME/.cache/go/mod";
    };

    home-manager.users.wux = {
        home.packages = with pkgs; [
            imagemagick
        ];

        programs.bash.enable = true;
        programs.git.enable = true;
        programs.neovim.enable = true;

        xdg.configFile."wgetrc".text = "hsts_file = \"~/.cache/wget-hsts\"";
    };

    system.stateVersion = "24.11";
}
