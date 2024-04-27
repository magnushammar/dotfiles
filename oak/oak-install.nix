{ config, pkgs, ... }:
let
  # Read the JSON file and decode it
  jsonContent = builtins.readFile "./systemParams.json";
  systemParams = builtins.fromJSON jsonContent;
in
{

  imports = [
    (import ./oak-filesystems.nix { inherit systemParams; })
  ]
  
  console.keyMap = "sv-latin1";
  users.users.hammar = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialHashedPassword = "${systemParams.hashedPassword}";
  };

  system.stateVersion = "23.11";
}
