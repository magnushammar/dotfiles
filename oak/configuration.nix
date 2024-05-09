{ config, pkgs, pkgs-unstable, lib, ... }:
let
  customQuickemu = pkgs-unstable.quickemu.override {
    qemu = pkgs.qemu_full;
  };
in
{
  
  imports = [
    ./base.nix
  ];

  environment.systemPackages = [
    pkgs.kate
    pkgs.git
    pkgs.dotnet-sdk_8 # keep other versions in nix-shells
    pkgs.docker
    pkgs.cifs-utils
    pkgs.zip
    pkgs.dropbox
    customQuickemu
    pkgs.yubikey-manager
    pkgs.ghostscript
  ];

  security.pam.u2f.enable = true;
  services.pcscd.enable = true;

  services.dbus.packages = [ 
    pkgs.cups
    pkgs.system-config-printer ];


  services.printing = {
    enable = true;
    drivers = [pkgs.hplip];
    logLevel = "debug";
  };

  services.samba = {
    enable = true;  # Enable the Samba service
    extraConfig = ''
      [global]
      workgroup = WORKGROUP
      security = user
      map to guest = Bad User
      guest account = nobody
      
      [public]
      path = /home/hammar/Public
      public = yes
      writable = yes
      guest ok = yes

      [dropbox]
      path = /home/hammar/data/Dropbox
      valid users = hammar, @users
      writable = yes
      printable = no
      guest ok = no
      force user = hammar
      force group = users
      create mask = 0660
      directory mask = 0770
    '';
  };

  networking.firewall.allowedTCPPorts = [ 139 445 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];

  #   ########## Network File Systems ##########
  fileSystems."/home/hammar/rygel/files" = {
    device = "//rygel.local/files";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/rygelcredentials"
      "uid=${toString config.users.users.hammar.uid}"
      "gid=${toString config.users.groups.users.gid}"
      "file_mode=0660"
      "dir_mode=0770"
      "noauto"
      "x-systemd.automount"
    ];
  };

  fileSystems."/home/hammar/rygel/arkiv" = {
    device = "//rygel.local/arkiv";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/rygelcredentials"
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
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = false;
  };

  ########## REGIONAL & LOCALE ##########

  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.xkb.layout = "se";
  time.timeZone = "Europe/Stockholm";
  services.timesyncd.enable = true;
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
    };
  };

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
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;

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
 virtualisation.spiceUSBRedirection.enable = true;
 services.spice-vdagentd.enable = true;

}
