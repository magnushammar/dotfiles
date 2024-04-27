{
  imports = [ ./hardware-configuration.nix ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
}
