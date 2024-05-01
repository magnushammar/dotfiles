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

  # ZFS Filesystem
  fileSystems."/" = { device = "zpool/root"; fsType = "zfs"; };
  fileSystems."/nix" = { device = "zpool/nix"; fsType = "zfs"; };
  fileSystems."/var" = { device = "zpool/var"; fsType = "zfs"; };
  fileSystems."/home" = { device = "zpool/home"; fsType = "zfs"; };
  fileSystems."/home/hammar/data" = { device = "zpool/home/data"; fsType = "zfs"; };
  fileSystems."/home/hammar/github" = { device = "zpool/home/github"; fsType = "zfs"; };
  fileSystems."/home/hammar/clickhouse" = { device = "zpool/home/clickhouse"; fsType = "zfs"; };

  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.interval = "weekly";


  # Boot Filesystem
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/${systemParams.espUUID}"; fsType = "vfat"; };

  # Secondary EXT4 Filesystem
  fileSystems."/home/hammar/secondary" = { device = "/dev/disk/by-uuid/${systemParams.ext4UUID}"; fsType = "ext4"; };

  # Backup Filesystem (TODO: parameterize based on serialnumber)
  # fileSystems."/home/hammar/backup" = {
  #   device = "/dev/disk/by-uuid/8d02c6fd-a621-490e-bdad-643fbb22be1d";
  #   fsType = "ext4";
  #   options = [ "noatime" "nodiratime" ];
  # };
  
  swapDevices = [ ];
  
  # Adding system activation script to change owner of extra user directories
  systemd.services.setDataOwnership = {
    description = "Set ownership for /home/hammar/{extra} directories";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-user-sessions.service" ]; # Trigger after user sessions are ready
    #partOf = [ "systemd-user-sessions.service" ]; # Consider this part of user session setup
    serviceConfig = {
      Type = "oneshot";
      RemainsAfterExit = false;
      ExecStart = ''
        ${pkgs.coreutils}/bin/chown -R hammar:users /home/hammar/data
        ${pkgs.coreutils}/bin/chown -R hammar:users /home/hammar/github
        ${pkgs.coreutils}/bin/chown -R hammar:users /home/hammar/clickhouse
      '';
    };
  };

  
  #console.keyMap = "sv-latin1";
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
