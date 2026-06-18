{ config, pkgs, ... }:

{
  home.username = "locks";
  home.homeDirectory = "/home/locks";
  home.stateVersion = "26.05";

  #alias stuff
  programs.bash = {
    enable = true;
    shellAliases = {
      nix-switch = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      ff         = "fastfetch";
    };
    initExtra = ''
      fastfetch
    '';
  };

  #Kitty Configuration
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
      remember_window_size = false;
      initial_window_width = 1000;
      initial_window_height = 650;
    };
  };

  #Starship
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = { padding = { top = 1; left = 2; }; };
      modules = [
        "title" "separator" "os" "kernel" "uptime" 
        "packages" "shell" "de" "wm" "terminal" 
        "cpu" "gpu" "memory" "disk"
      ];
    };
  };

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
