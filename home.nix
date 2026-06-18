{ config, pkgs, ... }:

{
  home.username = "locks";
  home.homeDirectory = "/home/locks";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    fishPlugins.tide
    fastfetch 
  ];

  # Explicit shell configuration with strict launch guard
  programs.fish = {
    enable = true;
    
    shellAbbrs = {};
    
    # Using shellAliases prevents the long command from expanding visually on your prompt
    shellAliases = {
      ff         = "fastfetch --structure title:separator:os:kernel:uptime:packages:shell:de:wm:terminal:cpu:gpu:memory:disk:break:colors";
      nix-switch = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    };
    
    interactiveShellInit = ''
      set -g fish_greeting ""

      if status is-interactive; and not set -q NM_FF_RUN
        set -g NM_FF_RUN 1
        fastfetch --structure title:separator:os:kernel:uptime:packages:shell:de:wm:terminal:cpu:gpu:memory:disk:break:colors
      end
    '';
  };

  # Declarative Kitty Configuration
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font";
      size = 12; 
    };
    settings = {
      shell = "${pkgs.fish}/bin/fish"; 
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0; 
      remember_window_size = false;
      initial_window_width = 1000;
      initial_window_height = 650;
    };
  };

  # Declarative Git Configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "locks";
        email = "shriveled999milp@proton.me"; 
      };
      init.defaultBranch = "main";
    };
  };
}
