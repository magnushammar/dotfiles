# NixOS config
Embryo of a NixOS config/setup. Let's see where it leads. Disclaimer. Take no advice from this :)

### Bootstrapping the Oak-desktop
oak/install.sh
oak/install.nix

```
sudo loadkeys sv-latin
curl -o install.sh https://github.com/magnushammar/dotfiles.git
chmod +x install.sh
sudo install.sh
sudo nixos-install
reboot
```

## Configurations
Organized by machine/name

#### This is a skinny KDE Plasma 5
Just Kate and Git  
- oak/base/flake.nix  
- oak/base/configuration.nix  

#### This is my live setup with KDE Plasma 5
Every app and with home manager  
- oak/live/flake.nix  
- oak/live/configuration.nix  
- oak/live/home.nix  

## Installation
```sh
nix-shell -p git
git clone https://github.com/magnushammar/dotfiles.git
cd dotfiles/oak/base #Or whatever configuration ofc.
sudo nixos-rebuild switch --impure --flake .#oak
```
`--impure` to be able to read `systemParams.json` from `/etc/nixos/`

## Todo
- [ ] Fix the tripple password request bug in install.sh  
- [ ] Set up secrets with Agenix

071