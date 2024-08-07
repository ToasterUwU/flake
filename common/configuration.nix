{ inputs, pkgs, config, ... }: {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    inputs.agenix.nixosModules.default
  ];
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # boot.kernelPackages = pkgs.linuxPackages_zen;

  programs.nix-ld.enable = true;
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

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
  services.libinput.touchpad.tapping = true;

  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.ledger.enable = true;

  hardware.sane.enable = true;
  services.printing.enable = true;
  hardware.sane.extraBackends = with pkgs; [ sane-airscan samsung-unified-linux-driver ];
  services.printing.drivers = with pkgs; [ sane-airscan samsung-unified-linux-driver ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

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

  services.fstrim.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Electron Apps in Wayland

  age.secrets = {
    "aki-password".file = ../secrets/common/aki-password.age;
    "scarlett-password".file = ../secrets/common/scarlett-password.age;
  };

  users.mutableUsers = false;
  users.users =
    {
      aki = {
        isNormalUser = true;
        description = "Aki";
        uid = 1000;
        hashedPasswordFile = config.age.secrets."aki-password".path;
        extraGroups = [ "networkmanager" "wheel" "plugdev" "scanner" "lp" ];
        packages = with pkgs; [
          openscad-unstable
          freecad
          ledger-live-desktop
          monero-gui
          chromedriver
          protonmail-desktop
          intiface-central
        ];
      };
      scarlett = {
        isNormalUser = true;
        description = "Scarlett";
        extraGroups = [ "networkmanager" "wheel" "plugdev" "scanner" "lp" ];
        uid = 1001;
        hashedPasswordFile = config.age.secrets."scarlett-password".path;
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
    pciutils
    fira-code
    fira-code-nerdfont
    starship
    fd
    ripgrep
    bat
    bottom
    tealdeer
    wget
    curl
    zoxide
    vdhcoapp
    gnupg
    git
    nano
    torrenttools
    gparted
    usbimager
    baobab
    angryipscanner
    obs-studio
    vlc
    kdePackages.kdenlive
    bitwarden
    vesktop
    tor-browser
    chromium
    spotify
    jellyfin-media-player
    simple-scan
    pdfarranger
    handbrake
  ] ++ [ inputs.agenix.packages.x86_64-linux.default ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = with pkgs; [ vdhcoapp ];
  };

  services.teamviewer.enable = true;

  services.openssh.enable = true;
  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host *
        StrictHostKeyChecking accept-new
    '';
  };

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
  catppuccin.accent = "pink";

  system.autoUpgrade = {
    enable = true;
    flake = "github:ToasterUwU/flake";
    flags = [ "--verbose" ];
    dates = "daily";
    operation = "boot";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  programs.fuse.userAllowOther = true;
  fileSystems = {
    "/home/aki/Gutruhn/home" = {
      device = "Aki@toasteruwu.com:/home";
      fsType = "fuse.sshfs";
      options =
        [
          "x-gvfs-show"
          "delay_connect"
          "reconnect"
          "ServerAliveInterval=10"
          "ServerAliveCountMax=2"
          "x-systemd.automount"
          "x-systemd.requires=network-online.target"
          "_netdev"
          "user"
          "transform_symlinks"
          "IdentityFile=/home/aki/.ssh/id_ed25519"
          "allow_other"
          "default_permissions"
          "uid=1000"
          "gid=100"
          "exec"
        ];
    };
    "/home/aki/Gutruhn/backups" = {
      device = "Aki@toasteruwu.com:/backups";
      fsType = "fuse.sshfs";
      options =
        [
          "x-gvfs-show"
          "delay_connect"
          "reconnect"
          "ServerAliveInterval=10"
          "ServerAliveCountMax=2"
          "x-systemd.automount"
          "x-systemd.requires=network-online.target"
          "_netdev"
          "user"
          "transform_symlinks"
          "IdentityFile=/home/aki/.ssh/id_ed25519"
          "allow_other"
          "default_permissions"
          "uid=1000"
          "gid=100"
          "exec"
        ];
    };
    "/home/aki/Gutruhn/data" = {
      device = "Aki@toasteruwu.com:/data";
      fsType = "fuse.sshfs";
      options =
        [
          "x-gvfs-show"
          "delay_connect"
          "reconnect"
          "ServerAliveInterval=10"
          "ServerAliveCountMax=2"
          "x-systemd.automount"
          "x-systemd.requires=network-online.target"
          "_netdev"
          "user"
          "transform_symlinks"
          "IdentityFile=/home/aki/.ssh/id_ed25519"
          "allow_other"
          "default_permissions"
          "uid=1000"
          "gid=100"
          "exec"
        ];
    };
    "/home/aki/Gutruhn/web" = {
      device = "Aki@toasteruwu.com:/web";
      fsType = "fuse.sshfs";
      options =
        [
          "x-gvfs-show"
          "delay_connect"
          "reconnect"
          "ServerAliveInterval=10"
          "ServerAliveCountMax=2"
          "x-systemd.automount"
          "x-systemd.requires=network-online.target"
          "_netdev"
          "user"
          "transform_symlinks"
          "IdentityFile=/home/aki/.ssh/id_ed25519"
          "allow_other"
          "default_permissions"
          "uid=1000"
          "gid=100"
          "exec"
        ];
    };
    "/home/aki/Gutruhn/docker" = {
      device = "Aki@toasteruwu.com:/docker";
      fsType = "fuse.sshfs";
      options =
        [
          "x-gvfs-show"
          "delay_connect"
          "reconnect"
          "ServerAliveInterval=10"
          "ServerAliveCountMax=2"
          "x-systemd.automount"
          "x-systemd.requires=network-online.target"
          "_netdev"
          "user"
          "transform_symlinks"
          "IdentityFile=/home/aki/.ssh/id_ed25519"
          "allow_other"
          "default_permissions"
          "uid=1000"
          "gid=100"
          "exec"
        ];
    };
  };

  system.stateVersion = "23.11";
}
