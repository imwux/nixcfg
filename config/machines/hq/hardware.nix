{ config, lib, pkgs, inputs, ... }:
let
    disks = {
        boot = "/dev/disk/by-uuid/7676-8D46";
        main = "/dev/disk/by-uuid/166e20da-21a5-4e34-b886-1910eeeefc28";
        swap = "/dev/disk/by-uuid/6d4037db-1637-4160-a6d2-9959b350a035";
    };
in {
    imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [];

    environment.systemPackages = with pkgs; [ sbctl ];

    boot.loader.grub.enable = lib.mkForce false;

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
    };

    fileSystems = {
        "/boot" = {
            device = disks.boot;
            fsType = "vfat";
            options = [ "fmask=0022" "dmask=0022" ];
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
            options = [ "noatime" "subvol=nix" ];
            neededForBoot = true;
        };
        "/persistent" = {
            device = disks.main;
            fsType = "btrfs";
            options = [ "subvol=persistent" ];
            neededForBoot = true;
        };
    };

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

    swapDevices = [ { device = disks.swap; } ];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    hardware = {
        enableRedistributableFirmware = true;

        graphics = {
            enable = true;
            enable32Bit = true;
        };

        cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
    };
}
