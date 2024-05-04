{ pkgs ? import <nixpkgs> {} }:

let
  quickemu = import ./default.nix {
    inherit (pkgs) lib stdenv fetchFromGitHub makeWrapper installShellFiles qemu gnugrep gnused lsb-release jq procps python3 cdrtools usbutils util-linux socat spice-gtk swtpm unzip wget xdg-user-dirs;
    inherit (pkgs.xorg) xrandr;  # Corrected reference to xrandr
  };
in
pkgs.stdenv.mkDerivation {
  name = "quickemu-environment";
  buildInputs = [ quickemu ];
}
