{
    config,
    lib,
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
    nixpkgs.hostPlatform = "x86_64-linux";

    networking.useDHCP = lib.mkDefault true;

    boot = {
        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];

        loader = {
            grub.enable = lib.mkForce false;
            systemd-boot.enable = true;

            efi = {
                efiSysMountPoint = "/boot";
                canTouchEfiVariables = true;
            };
        };

        initrd = {
            availableKernelModules = [
                "nvme"
                "xhci_pci"
                "thunderbolt"
                "usb_storage"
                "sd_mod"
                "sdhci_pci"
            ];
            kernelModules = [ ];

            systemd = {
                enable = true;

                services.impermanence-btrfs = {
                    description = "Btrfs root migration for impermanence";
                    wantedBy = [ "initrd-root-device.target" ];
                    after = [
                        "initrd-root-device.target"
                    ];
                    before = [ "sysroot.mount" ];
                    unitConfig.DefaultDependencies = false;
                    serviceConfig.Type = "oneshot";
                    script = ''
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
                };
            };
        };
    };

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
