{ config, pkgs, pkgs-unstable, lib, ... }:

let
  # Determine the base path based on the existence of /mnt/etc/nixos
  basePath = if builtins.pathExists "/mnt/etc/nixos/configuration.nix" then "/mnt" else "";
  jsonPath = "${basePath}/etc/nixos/systemParams.json";

  # Read the JSON file and decode it
  jsonContent = builtins.readFile jsonPath;
  systemParams = builtins.fromJSON jsonContent;
in
{
    

  home.packages = [
    pkgs.spotify
    pkgs.bitwarden-cli
    pkgs.bitwarden
    pkgs.firefox
    pkgs.google-chrome
    pkgs.jetbrains.rider
    #pkgs.jetbrains.datagrip
    pkgs.obsidian
    pkgs.github-desktop
    pkgs.libreoffice-fresh
    pkgs.jetbrains.datagrip
    pkgs.todoist-electron
    pkgs.todoist-electron
    pkgs.microsoft-edge
    pkgs.yubikey-personalization-gui
    pkgs.github-cli
    pkgs.kcalc
    pkgs.vlc
    pkgs-unstable.masterpdfeditor
    pkgs.desktop-file-utils
    pkgs.guvcview
    pkgs-unstable.vscode
    pkgs-unstable.jetbrains.phpstorm
    pkgs.ngrok
    pkgs.pandoc
    pkgs.texlive.combined.scheme-full
    pkgs.flyctl
    pkgs.brave
    pkgs.veracrypt
    pkgs.chromium
    pkgs.signal-desktop
    pkgs.distrobox
  ];

  

  programs.vscode = {
    extensions = with pkgs.vscode-extensions; [
      "ms-dotnettools.vscode-dotnet-runtime"
      "ms-dotnettools.csharp"
      "mkhl.direnv"
      "GitHub.copilot-chat"
      "GitHub.vscode-pull-request-gzooithub"
      "npxms.hide-gitignored"
      "Ionide.Ionide-fsharp"
      "rangav.vscode-thunder-client"
      "CompilouIT.xkb"
      "sourcegraph.cody-ai"
      "GitHub.copilot"
      "arrterian.nix-env-selector"
      "ms-vscode-remote.remote-ssh"
      "ms-vscode-remote.remote-ssh-explorer"
      "jnoortheen.nix-ide" 
      "ms-python.python"
    ];
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

      alias calc=kcalc
      alias vmwin11="quickemu --vm ~/data/vms/windows-11.conf"
      alias vmwin11-reconnect='nohup remote-viewer spice://127.0.0.1:5930 > /dev/null 2>&1 &'

      eval "$(direnv hook bash)"

     # xkbcomp ${config.home.homeDirectory}/.custom.xkb $DISPLAY

     # Source environment variables from external file
         if [ -f ~/.env_vars ]; then
           source ~/.env_vars
         fi

      export LC_ALL=en_US.UTF-8

      source ~/dotfiles/scripts/goto.sh


    '';
  };

  # home.sessionPath = [ "${pkgs.jetbrains.pycharm-professional}/bin" ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  home.username = "hammar";
  home.homeDirectory = "/home/hammar";

  xsession.numlock.enable = true;

  home.stateVersion = "23.11"; 
  home.file = {
    
  };

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
}
