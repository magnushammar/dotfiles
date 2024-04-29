{ config, pkgs, lib, ... }:

{
  
  imports = [
    ../install.nix
  ];

    ########## Network File Systems ##########
  fileSystems."/mnt/rygel/files" = {
    device = "//rygel/files";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/hammar-nixos-cfg/rygelcredentials"
      "uid=${toString config.users.users.hammar.uid}"
      "gid=${toString config.users.groups.users.gid}"
      "file_mode=0660"
      "dir_mode=0770"
      "noauto"
      "x-systemd.automount"
    ];
  };

  fileSystems."/mnt/rygel/arkiv" = {
    device = "//rygel/arkiv";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/hammar-nixos-cfg/rygelcredentials"
      "uid=${toString config.users.users.hammar.uid}"
      "gid=${toString config.users.groups.users.gid}"
      "file_mode=0660"
      "dir_mode=0770"
      "noauto"
      "x-systemd.automount"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  ########## NIX  ##########
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ########## GRAPHICS ##########
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  ########## DESKTOP ENVIRONMENT ##########
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = false;

  ########## REGIONAL & LOCALE ##########

  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.xkb.layout = "se";
  time.timeZone = "Europe/Stockholm";
  services.timesyncd.enable = true;
  i18n.defaultLocale = "sv_SE.UTF-8";

  ########## OTHER HARDWARE ##########

  sound.enable = true;
  ## hardware.pulseaudio.enable = true;
  hardware.pulseaudio = {
  enable = true;
  extraConfig = ''
    set-default-sink alsa_output.pci-0000_00_1b.0.analog-stereo
    set-default-source alsa_input.pci-0000_00_1b.0.analog-stereo
  '';
};

  ########## NETWORKING ##########

  networking.networkmanager.enable = true;

  environment.etc."nsswitch.conf".text = ''
   hosts: files mdns_minimal [NOTFOUND=return] dns mdns
  '';
 
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  networking.hosts = {
    "192.168.68.52" = ["rygel"];
    "192.168.68.54" = ["thermia"];
    "127.0.0.1" = ["localhost"];
    "127.0.1.1" = ["oak"];
  };

  ########## SOFTWARE ##########
  
 nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
   "nvidia-x11"
   "nvidia-settings"
 ];

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    kate
    git
    wget
    dotnet-sdk_8 # keep other versions in nix-shells
    samba
    docker
    cifs-utils
    zip
    lsof
    lolcat
  ];

}
