{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.blacklistedKernelModules = [ "nouveau" ];

  # Networking
  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;

  # Locales & Time
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Graphical Services (KDE Plasma 6)
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Strip down KDE Plasma default software bloat
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa         # Default music player
    khelpcenter   # Help documentation manual
    konsole       # Default terminal emulator (You use Kitty!)
  ];

  # Audio & Printing
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Hardware / Nvidia PRIME Configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Crucial for 32-bit graphics/Wine/Proton gaming acceleration
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false; # Keeps performance optimal on high-end laptops
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Enable the Fish shell system-wide and strip vendor conflict layers
  programs.fish = {
    enable = true;
    vendor.config.enable = false; # Prevents system script collision with home-manager
  };

  # User Account
  users.users."locks" = {
    isNormalUser = true;
    description = "locks";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish; 
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Pass control of user configurations cleanly over to home.nix
  home-manager.users.locks = import ./home.nix;

  # System-wide Packages & Programs
  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    fastfetch
    git
    vim
    wget
    openrgb
    kitty
    nerd-fonts.iosevka
  ];

  programs.firefox.enable = true;
  
  # Gaming Optimizations
  programs.steam.enable = true;
  programs.gamemode.enable = true; 

  # Nix Storage Optimization & Flakes Setup
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "26.05"; 
}
