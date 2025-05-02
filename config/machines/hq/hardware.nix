{ lib, config, pkgs, inputs, ... }:
{
    imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [];

    environment.systemPackages = [ pkgs.sbctl ];
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
    };

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-uuid/cad90b3a-bef4-465b-827f-667e5128af9b";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-uuid/26C8-1EEC";
            fsType = "vfat";
            options = [ "fmask=0077" "dmask=0077" ];
        };
        "/nix" = {
            device = "/dev/disk/by-uuid/84fe2783-8bea-4766-b6f2-c62d7ef12abf";
            fsType = "ext4";
            neededForBoot = true;
            options = [ "noatime" ];
        };
    };

    swapDevices = [
        { device = "/dev/disk/by-uuid/7c284ecd-ca13-48fd-ac14-1167b3017c40"; }
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
