{
    config,
    lib,
    pkgs,
    ...
}:
let
    disks = {
        boot = "/dev/disk/by-uuid/E79A-08D2";
        main = "/dev/disk/by-uuid/a6e23491-5849-4575-8b0a-9b1993db6151";
        swap = "/dev/disk/by-uuid/268f3ad9-0b9e-4517-a0ef-a724600261ac";
    };
in
{
    boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
    ];
    boot.initrd.kernelModules = [ ];

    boot.kernelPackages =
        let
            linuxPackages = pkgs.linuxPackages_6_17;
        in
        builtins.trace "Built against kernel ${linuxPackages.kernel.version}" linuxPackages;
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    boot.loader.grub.enable = lib.mkForce false;
    boot.loader.systemd-boot.enable = true;

    boot.loader.efi.efiSysMountPoint = "/boot";
    boot.loader.efi.canTouchEfiVariables = true;

    fileSystems = {
        "/boot" = {
            device = disks.boot;
            fsType = "vfat";
            options = [
                "fmask=0022"
                "dmask=0022"
            ];
        };
        "/" = {
            device = disks.main;
            fsType = "btrfs";
            options = [ "subvol=root" ];
            neededForBoot = true;
        };
        "/nix" = {
            device = disks.main;
            fsType = "btrfs";
            options = [
                "noatime"
                "subvol=nix"
            ];
            neededForBoot = true;
        };
        "/persistent" = {
            device = disks.main;
            fsType = "btrfs";
            options = [ "subvol=persistent" ];
            neededForBoot = true;
        };
    };

    swapDevices = [ { device = disks.swap; } ];

    boot.initrd.postResumeCommands = lib.mkAfter ''
        TMPDIR="/impermanence_btrfs_tmp"
        mkdir $TMPDIR
        mount ${disks.main} $TMPDIR
        if [[ -e $TMPDIR/root ]]; then
            mkdir -p $TMPDIR/old_roots
            timestamp=$(date --date="@$(stat -c %Y $TMPDIR/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv $TMPDIR/root "$TMPDIR/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for IDX in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "$TMPDIR/$IDX"
            done
            btrfs subvolume delete "$1"
        }

        for IDX in $(find $TMPDIR/old_roots/ -maxdepth 1 -mtime +3); do
            delete_subvolume_recursively "$IDX"
        done

        btrfs subvolume create $TMPDIR/root
        umount $TMPDIR
    '';

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    services.fwupd.enable = true;

    hardware = {
        enableRedistributableFirmware = true;

        graphics = {
            enable = true;
            enable32Bit = true;
        };

        cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
    };
}
