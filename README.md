# NixOS config
Embryo of a NixOS config/setup. Let's see where it leads. Take no advice from this :)

## Structure.
I like my long descriptive file names as I easily get confused when I on occation edit several configuration.nix at the same time. Separate folders might be a future thing but I am an opponent of premature folderization! 

common/configuration.nix  
oak/oak-bootstrap.sh  
oak/oak-bootstrap.nix  
oak/oak-base-configuration.nix  
oak/oak-base-flake.nix  
oak/oak-base-home.nix  
oak/oak-live-configuration.nix  
oak/oak-live-flake.nix  
oak/oak-live-home.nix  

## Installation.

### OS, Filesystem and Git
- boot live usb
- execute bootstrap.sh
- for the time being, manual `sudo nixos-install && reboot`

### Move to basic Flake configuration
- manual config of Git
- clone dotfiles from https://github.com/magnushammar/dotfiles.git
- set up base symlinks
- rebuild

### Move to live Flake configuration
- copy base to live if not exists
- set up live symlinks
- rebuild