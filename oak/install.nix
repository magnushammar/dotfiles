{ config, pkgs, lib, ... }:
let
  # Determine the base path based on the existence of /mnt/etc/nixos
  basePath = if builtins.pathExists "/mnt/etc/nixos/configuration.nix" then "/mnt" else "";
  jsonPath = "${basePath}/etc/nixos/systemParams.json";

  # Read the JSON file and decode it
  jsonContent = builtins.readFile jsonPath;
  systemParams = builtins.fromJSON jsonContent;
in
{
  # Add the flakes configuration here
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

  environment.systemPackages = with pkgs; [
    git
  ];

  system.stateVersion = "23.11";
}
