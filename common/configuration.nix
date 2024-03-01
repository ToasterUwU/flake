{ inputs, pkgs, nixpkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

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

  users.users.aki = {
    isNormalUser = true;
    description = "Aki";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      vesktop
      jellyfin-media-player
      bitwarden
      freecad
      ledger-live-desktop
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.steam.enable = true;

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "aki" ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "aki" ];

  environment.systemPackages = with pkgs; [
    fuse
    sshfs
    hyfetch
    wget
    curl
    git
    python3
    rustup
    nodejs
    nano
    wineWowPackages.stable
    winetricks
    angryipscanner
    teamviewer
    obs-studio
    libsForQt5.kdenlive
    firefox
    tor-browser
    spotify
    onlyoffice-bin
    obsidian
    pkgs.gnome.simple-scan
    handbrake
    prismlauncher-qt5
    protonup-qt
    papirus-icon-theme
    papirus-folders
  ];

  services.openssh.enable = true;

  system.stateVersion = "23.11";
}
