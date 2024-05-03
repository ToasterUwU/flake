{ inputs, pkgs, ... }: {
  nixpkgs.overlays = [ inputs.envision.overlays.default ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  programs.nix-ld.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  console.keyMap = "de";

  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Electron Apps in Wayland

  users.users =
    {
      aki = {
        isNormalUser = true;
        description = "Aki";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
          freecad
          ledger-live-desktop
          chromium
          chromedriver
          protonmail-desktop
          intiface-central
        ];
      };
      scarlett = {
        isNormalUser = true;
        description = "Scarlett";
        packages = with pkgs; [
          brave
        ];
      };
    };

  environment.systemPackages = with pkgs; [
    fuse
    sshfs
    sshpass
    fastfetch
    hyfetch
    wget
    curl
    gnupg
    git
    nano
    torrenttools
    gparted
    baobab
    angryipscanner
    teamviewer
    obs-studio
    vlc
    libsForQt5.kdenlive
    bitwarden
    vesktop
    firefox
    tor-browser
    spotify
    jellyfin-media-player
    onlyoffice-bin
    obsidian
    gnome.gnome-clocks
    gnome.simple-scan
    handbrake
    papirus-icon-theme
    papirus-folders
  ];

  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    dates = "daily";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.stateVersion = "23.11";
}
