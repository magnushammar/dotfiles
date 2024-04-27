{ config, pkgs, ... }:
let
  # Read the JSON file and decode it
  jsonContent = builtins.readFile "./systemParams.json";
  systemParams = builtins.fromJSON jsonContent;
in
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
  
  console.keyMap = "sv-latin1";
  users.users.hammar = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialHashedPassword = "${systemParams.hashedPassword}";
  };

  system.stateVersion = "23.11";
}
