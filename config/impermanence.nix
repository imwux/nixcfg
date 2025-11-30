{ inputs, ... }:
let
    passwordFile = "/persistent/password.txt";
in {
    imports = [ inputs.impermanence.nixosModules.impermanence ];

    users.mutableUsers = false;

    users.users.root.hashedPasswordFile = passwordFile;
    users.users.wux.hashedPasswordFile = passwordFile;

    home-manager.users.wux.imports = [ ({ config, ... }: {
        home.file = {
            tmp.source = config.lib.file.mkOutOfStoreSymlink "/persistent/tmp";
            nixcfg.source = config.lib.file.mkOutOfStoreSymlink "/persistent/nixcfg";
            projects.source = config.lib.file.mkOutOfStoreSymlink "/persistent/projects";
        };
    }) ];

    environment.persistence."/persistent/root" = {
        hideMounts = true;
        directories = [
            "/var/log"
            "/var/lib/nixos"
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
                { directory = ".pki"; mode = "0700"; }
                { directory = ".ssh"; mode = "0700"; }

                # .config
                ".config/aseprite"
                ".config/blender"
                ".config/Code"
                ".config/discord"
                ".config/FreeCAD"
                ".config/gdb" # Maybe we hardcode this using nix? (gdbinit)
                ".config/GIMP"
                ".config/imhex"
                ".config/kicad"
                ".config/OrcaSlicer"
                ".config/spotify"
                ".config/uwsm" # Maybe hardcode this too ?
                ".config/vlc"

                # .local
                ".local/state/wireplumber"
                ".local/share/FreeCAD"
                ".local/share/gvfs-metadata" # Might be unecessary
                ".local/share/imhex"
                ".local/share/kicad"
                ".local/share/orca-slicer"
                ".local/share/PrismLauncher"
                ".local/share/Steam"
                ".local/share/zed" # We could hardcode the things we want here for fun too
            ];
            files = [
                ".bash_history"
                ".wget-hsts"

                # .local
                ".local/share/recently-used.xbel"
            ];
        };
    };
}
