# NixOS config
Embryo of a NixOS config/setup. Let's see where it leads. Take no advice from this :)

## Structure.

oak/common-modules.nix  
oak/install.sh  
oak/install.nix  
oak/base/configuration.nix  
oak/base/flake.nix  
oak/base/home.nix  
oak/live/configuration.nix  
oak/live/flake.nix  
oak/live/home.nix  

## Installation.

### OS, Filesystem and Git
- boot live usb
- execute install.sh
- for the time being, manual `sudo nixos-install && reboot`

### Move to basic Flake configuration
- `nix-shell -p git`
- clone dotfiles from https://github.com/magnushammar/dotfiles.git
- go to your dotfiles machine configuration
- `sudo nixos-rebuild switch --impure --flake .#oak` (#configuration-name)

### Move to live Flake configuration
