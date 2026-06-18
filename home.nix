{ config, pkgs, ... }:

{
  home.username = "locks";
  home.homeDirectory = "/home/locks";

  # User packages
  home.packages = with pkgs; [
    # Add personal utilities here
  ];

  # Declarative Kitty Configuration
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font";
      size = 12; 
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0; 

      # Forces Kitty to open at a specific larger layout (Width x Height in pixels)
      remember_window_size = false;
      initial_window_width = 1000;
      initial_window_height = 650;
    };
  };

  # Custom Shortcuts & Startup Behaviour for Bash
  programs.bash = {
    enable = true;
    shellAliases = {
      nix-switch = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      ff         = "fastfetch";
    };
    
    # Automatically triggers when an interactive terminal session opens
    initExtra = ''
      fastfetch
    '';
  };

  # Custom Minimalist & Privacy-Focused Fastfetch Configuration
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        padding = {
          top = 1;
          left = 2;
        };
      };
      modules = [
        "title"
        "separator"
        "os"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "de"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "disk"
      ];
    };
  };

  # Modern Declarative Git Configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "locks";
        email = "shriveled999milp@proton.me"; 
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Match this to your system's stateVersion
  home.stateVersion = "26.05"; 
}
