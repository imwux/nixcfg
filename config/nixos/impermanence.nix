{ inputs, ... }:
let
    passwordFile = "/persistent/password.txt";
in
{
    imports = [ inputs.impermanence.nixosModules.impermanence ];

    users.mutableUsers = false;

    users.users.root.hashedPasswordFile = passwordFile;
    users.users.wux.hashedPasswordFile = passwordFile;

    home-manager.users.wux.imports = [
        (
            { config, ... }:
            {
                home.file = {
                    tmp.source = config.lib.file.mkOutOfStoreSymlink "/persistent/tmp";
                    nixcfg.source = config.lib.file.mkOutOfStoreSymlink "/persistent/nixcfg";
                    projects.source = config.lib.file.mkOutOfStoreSymlink "/persistent/projects";
                };
            }
        )
    ];

    environment.persistence."/persistent/root" = {
        hideMounts = true;
        directories = [
            "/var/log"
            "/var/lib/nixos"
            "/var/lib/sbctl"
            "/var/lib/systemd/coredump"
            "/etc/NetworkManager/system-connections"
        ];
        files = [
            "/etc/machine-id"
        ];
        users.wux = {
            directories = [
                "Downloads"
                ".mozilla"
                {
                    directory = ".pki";
                    mode = "0700";
                }
                {
                    directory = ".ssh";
                    mode = "0700";
                }
                ".rustup"

                # .config
                ".config/aseprite"
                ".config/blender"
                ".config/Code"
                ".config/vesktop"
                ".config/FreeCAD"
                ".config/gdb"
                ".config/GIMP"
                ".config/imhex"
                ".config/kicad"
                ".config/OrcaSlicer"
                ".config/spotify"
                ".config/uwsm"
                ".config/vlc"
                ".config/gh"
                ".config/SourceGit"

                # .local
                ".local/state/wireplumber"
                ".local/share/FreeCAD"
                ".local/share/imhex"
                ".local/share/karere"
                ".local/share/kicad"
                ".local/share/orca-slicer"
                ".local/share/PrismLauncher"
                ".local/share/Steam"
                ".local/share/zed"
                ".local/share/hyprland"
            ];
            files = [
                ".bash_history"
                ".wget-hsts"
            ];
        };
    };
}
