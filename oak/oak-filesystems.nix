# Oak file systems
{systemParams, lib, config, pkgs ...}:
{  
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
    ];
  };
  
  networking.hostId = "${systemParams.networkingHostId}";

  fileSystems."/" = { device = "zpool/root"; fsType = "zfs"; };
  fileSystems."/nix" = { device = "zpool/nix"; fsType = "zfs"; };
  fileSystems."/var" = { device = "zpool/var"; fsType = "zfs"; };
  fileSystems."/home" = { device = "zpool/home"; fsType = "zfs"; };
  fileSystems."/home/hammar/data" = { device = "zpool/home/data"; fsType = "zfs"; };
  fileSystems."/home/hammar/github" = { device = "zpool/home/github"; fsType = "zfs"; };
  fileSystems."/home/hammar/clickhouse" = { device = "zpool/home/clickhouse"; fsType = "zfs"; };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/${systemParams.espUUID}"; fsType = "vfat"; };
   
  swapDevices = [ ];
}