# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/1d98672f-f569-4b8a-8485-678e133817f8";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."slow_crypt".device = "/dev/disk/by-uuid/d7d68e21-5b1e-4962-a636-4bf84da30975";

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/1fc1341b-5386-43c2-aacf-8a51260348cc";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."fast_crypt".device = "/dev/disk/by-uuid/787b1ca4-1ba9-4729-a4dd-1cc8b072991c";

  fileSystems."/var" =
    { device = "/persist/var";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/etc/NetworkManager/system-connections" =
    { device = "/persist/etc/NetworkManager/system-connections";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/home" =
    { device = "/persist/home";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/root" =
    { device = "/persist/root";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/tmp" =
    { device = "/nix/tmp";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2509-5FDA";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
