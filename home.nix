{ config, pkgs, ... }:

{
  home.username = "locks";
  home.homeDirectory = "/home/locks";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    fishPlugins.tide
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      nix-switch = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      ff         = "fastfetch";
    };
    interactiveShellInit = ''
      set fish_greeting # Turn off the default welcome message
    '';
  };

  #kitty
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font";
      size = 12; 
    };
    settings = {
      shell = "${pkgs.fish}/bin/fish --init-command=fastfetch"; 
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0; 
      remember_window_size = false;
      initial_window_width = 1000;
      initial_window_height = 650;
    };
  };

  #minimal ff
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
