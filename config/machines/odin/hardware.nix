{
    lib,
    config,
    pkgs,
    ...
}:
{
    boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
    ];
    boot.initrd.kernelModules = [ "i915" ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelParams = [ "i915.enable_guc=2" ];

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-uuid/112835ba-9664-4753-862d-b7421aa1c5d6";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-uuid/D14F-3F94";
            fsType = "vfat";
            options = [
                "fmask=0077"
                "dmask=0077"
            ];
        };
    };

    swapDevices = [ { device = "/dev/disk/by-uuid/06d373d0-d269-4db6-80b3-56c23c1849ae"; } ];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = "x86_64-linux";

    services.fstrim.enable = true;

    services.thermald.enable = true;

    services.auto-cpufreq = {
        enable = true;
        settings = {
            battery = {
                governor = "powersave";
                turbo = "never";
            };
            charger = {
                governor = "performance";
                turbo = "auto";
            };
        };
    };

    hardware = {
        enableRedistributableFirmware = true;

        bluetooth.enable = true;

        graphics = {
            enable = true;
            enable32Bit = true;
            extraPackages = with pkgs; [
                intel-media-driver
                intel-compute-runtime
                vpl-gpu-rt
            ];
            extraPackages32 = with pkgs.driversi686Linux; [ intel-media-driver ];
        };

        nvidia = {
            open = false;
            modesetting.enable = true;
            powerManagement = {
                enable = true;
                finegrained = true;
            };
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.production;

            prime = {
                offload = {
                    enable = true;
                    enableOffloadCmd = true;
                };
                intelBusId = "PCI:0:2:0";
                nvidiaBusId = "PCI:1:0:0";
            };
        };

        cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
    };
}
