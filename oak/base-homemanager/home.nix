{ config, pkgs, lib, ... }:

let
  # Determine the base path based on the existence of /mnt/etc/nixos
  basePath = if builtins.pathExists "/mnt/etc/nixos/configuration.nix" then "/mnt" else "";
  jsonPath = "${basePath}/etc/nixos/systemParams.json";

  # Read the JSON file and decode it
  jsonContent = builtins.readFile jsonPath;
  systemParams = builtins.fromJSON jsonContent;
in
{

  home.packages = with pkgs; [
    #spotify
    #bitwarden-cli
    bitwarden
    #firefox
    google-chrome
    #jetbrains.rider
    #obsidian
    #vscode
    #github-desktop
    # vscode-insiders This one is tricky it seems https://nixos.wiki/wiki/Visual_Studio_Code
    #libreoffice-fresh
    #jetbrains.datagrip
    #todoist-electron
    #dropbox
    #jetbrains.pycharm-professional

  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # Source additional Bash settings from an external file
    initExtra = ''
      # Avoid duplicate entries and commands starting with space in history
      export HISTCONTROL=ignoreboth

      # Ensure the history is written after each command
      PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
    '';
  };

  home.username = "hammar";
  home.homeDirectory = "/home/hammar";

  home.stateVersion = "23.11"; # Please read update notes before changing.

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/hammar/etc/profile.d/hm-session-vars.sh
  #

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
