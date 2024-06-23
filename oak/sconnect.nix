{ config, lib, pkgs, ... }:

let
  sconnect-host = pkgs.callPackage ./sconnect-host.nix {};
in
{
  options = {
    services.sconnect = {
      enable = lib.mkEnableOption "SConnect Chrome Extension";
    };
  };

  config = lib.mkIf config.services.sconnect.enable {
    environment.etc."opt/chrome/native-messaging-hosts/com.gemalto.sconnect.json".text = builtins.toJSON {
      name = "com.gemalto.sconnect";
      description = "SConnect Chrome Native Messaging Host for Ubuntu";
      path = "${sconnect-host}/bin/sconnect_host_linux";
      type = "stdio";
      allowed_origins = [
        "chrome-extension://mjhbkkaddmmnkghdnnmkjcgpphnopnfk/"
      ];
    };

    systemd.user.services.sconnect-host = {
      description = "SConnect Host Service";
      wantedBy = [ "default.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${sconnect-host}/bin/sconnect_host_linux";
        Restart = "on-failure";
      };
    };
  };
}
