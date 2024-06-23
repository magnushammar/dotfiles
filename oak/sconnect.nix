{ config, lib, pkgs, ... }:

{
  options = {
    services.sconnect = {
      enable = lib.mkEnableOption "SConnect Hello World Debug";
    };
  };

  config = lib.mkIf config.services.sconnect.enable {
    systemd.user.services.sconnect-hello-world = {
      Unit = {
        Description = "SConnect Hello World Service";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.coreutils}/bin/echo Hello, World!";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
