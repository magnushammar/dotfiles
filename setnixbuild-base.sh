#!/bin/bash
DOTFILES_DIR="$HOME/dotfiles"
NIXOS_CONFIG_DIR="/etc/nixos"

# Backup the existing configuration.nix if it exists
if [ -f "$NIXOS_CONFIG_DIR/configuration.nix" ]; then
  echo "Existing configuration.nix found. Creating backup as configuration.nix.bak"
  sudo mv $NIXOS_CONFIG_DIR/configuration.nix $NIXOS_CONFIG_DIR/configuration.nix.bak
fi

# Symlink the configuration
sudo ln -sf $DOTFILES_DIR/oak/oak-base-flake.nix $NIXOS_CONFIG_DIR/flake.nix
sudo ln -sf $DOTFILES_DIR/oak/oak-base-configuration.nix $NIXOS_CONFIG_DIR/configuration.nix

echo "Configuration has been symlinked."sudo 