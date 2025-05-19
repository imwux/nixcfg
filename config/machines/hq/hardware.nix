{ config, lib, pkgs, inputs, ... }:
{
    imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [];

    environment.systemPackages = with pkgs; [ sbctl ];

    boot.loader.grub.enable = lib.mkForce false;
    boot.loader.systemd-boot.enable = lib.mkForce true;

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    # Setup when secure boot is actually needed
    #boot.loader.systemd-boot.enable = lib.mkForce false;
    #boot.lanzaboote = {
    #    enable = true;
    #    pkiBundle = "/etc/secureboot";
    #};

    fileSystems = {
        "/boot" = {
            device = "/dev/disk/by-uuid/7676-8D46";
            fsType = "vfat";
            options = [ "fmask=0022" "dmask=0022" ];
        };
        "/" = {
            device = "/dev/disk/by-uuid/166e20da-21a5-4e34-b886-1910eeeefc28";
            fsType = "btrfs";
            options = [ "subvol=root" ];
            neededForBoot = true;
        };
        "/nix" = {
            device = "/dev/disk/by-uuid/166e20da-21a5-4e34-b886-1910eeeefc28";
            fsType = "btrfs";
            options = [ "noatime" "subvol=nix" ];
            neededForBoot = true;
        };
        "/persistent" = {
            device = "/dev/disk/by-uuid/166e20da-21a5-4e34-b886-1910eeeefc28";
            fsType = "btrfs";
            options = [ "subvol=persistent" ];
            neededForBoot = true;
        };
    };

    swapDevices = [ { device = "/dev/disk/by-uuid/6d4037db-1637-4160-a6d2-9959b350a035"; } ];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    hardware = {
        enableRedistributableFirmware = true;

        graphics = {
            enable = true;
            enable32Bit = true;
            extraPackages = with pkgs; [
                amdvlk # TODO: zed was crashing radv. once this is fixed remove this
            ];
        };

        cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
    };
}
