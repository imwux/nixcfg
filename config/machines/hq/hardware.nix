{ config, lib, pkgs, inputs, ... }:
{
    imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [];

    environment.systemPackages = with pkgs; [ sbctl ];

    boot.loader.grub.enable = lib.mkForce false;
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    boot.lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
    };

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-uuid/39bcd032-9374-460f-9a1f-753fc80e61d6";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-uuid/B0E0-9ADD";
            fsType = "vfat";
            options = [ "fmask=0022" "dmask=0022" ];
        };
        "/nix" = {
            device = "/dev/disk/by-uuid/a66dad56-305a-4398-a4df-7397985ca0f2";
            fsType = "ext4";
            neededForBoot = true;
            options = [ "noatime" ];
        };
    };

    swapDevices = [
        { device = "/dev/disk/by-uuid/a62c31d9-80b4-4894-b5e7-e91893c2b599"; }
    ];

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
