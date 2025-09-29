{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    inputs.agenix.nixosModules.default
    inputs.arion.nixosModules.arion
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    ../pkgs/general-utils.nix
  ];
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "aki" ];

  # boot.kernelPackages = pkgs.linuxPackages_zen;
  zramSwap.enable = true;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

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

  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [ networkmanager-openvpn ];
  };
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.ledger.enable = true;

  hardware.sane.enable = true;
  services.printing.enable = true;
  hardware.sane.extraBackends = with pkgs; [
    sane-airscan
    samsung-unified-linux-driver
  ];
  services.printing.drivers = with pkgs; [
    sane-airscan
    samsung-unified-linux-driver
  ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.pulseaudio.enable = false;
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

  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # Electron Apps in Wayland
    NIXOS_OZONE_WL = "1"; # Electron Apps in Wayland NixOS specific
  };

  age.secrets = {
    "aki-password".file = ../secrets/common/aki-password.age;
  };

  users = {
    mutableUsers = false;
    users = {
      aki = {
        shell = pkgs.fish;
        isNormalUser = true;
        description = "Aki";
        uid = 1000;
        hashedPasswordFile = config.age.secrets."aki-password".path;
        linger = true;
        extraGroups = [
          "networkmanager"
          "wheel"
          "plugdev"
          "scanner"
          "lp"
        ];
      };
    };
  };

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      Preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "privacy.resistFingerprinting" = false;
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme,-JSDateTimeUTC";
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
        "webgl.disabled" = false;
      };
    };
  };

  environment.systemPackages =
    with pkgs;
    [
      fuse
      sshfs
      sshpass
      pciutils
      fira-code
      nerd-fonts.fira-code
      uutils-coreutils-noprefix
      wget
      curl
      yt-dlp
      gnupg
      git
      nano
      mkbrr
      gparted
      usbimager
      baobab
      dua
      rustscan
      nmap
      vlc
      kdePackages.kdenlive
      bitwarden-desktop
      vesktop
      mprisence
      element-desktop
      signal-desktop
      tor-browser
      chromium
      jellyfin-media-player
      supersonic
      mpv
      simple-scan
      pdfarranger
      makemkv
      handbrake
      mediainfo
      ffmpeg-full
      gearlever
      gimp3
      blender
      unityhub
      openscad-unstable
      orca-slicer
      (pkgs.writeShellScriptBin "ledger-live-desktop" ''
        # unset NIXOS_OZONE_WL for this app only
        exec env -u NIXOS_OZONE_WL ${pkgs.ledger-live-desktop}/bin/ledger-live-desktop "$@"
      '')
      monero-gui
      chromedriver
      intiface-central
      pyfa
      scrcpy
    ]
    ++ [
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          obs-vkcapture
          obs-vaapi
          obs-pipewire-audio-capture
          obs-mute-filter
        ];
      })
    ]
    ++ [ inputs.agenix.packages.x86_64-linux.default ];

  services.mediamtx = {
    enable = true;
    settings = {
      paths = {
        discordSucksSoIUseOBS = { };
      };
      webrtc = true;
    };
  };

  # MakeMKV requires sg kernel module, v4l2loopback for OBS virtual cam
  boot.kernelModules = [
    "sg"
    "v4l2loopback"
  ];

  # OBS Virtual Cam
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

  services.teamviewer.enable = true;

  services.openssh.enable = true;
  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host *
        StrictHostKeyChecking accept-new
    '';
  };
  services.gnome.gcr-ssh-agent.enable = false;

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
  catppuccin.accent = "pink";

  system.autoUpgrade = {
    enable = true;
    flake = "github:ToasterUwU/flake";
    flags = [
      "--verbose"
      "-j 1"
    ];
    dates = "9:00";
    operation = "boot";
  };

  systemd.services.nixos-upgrade = {
    onFailure = [ "notify-upgrade-failure.service" ];
  };

  systemd.services.notify-upgrade-failure = {
    description = "Notify on NixOS upgrade failure";
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    environment = {
      "DESKTOP" = ":0";
      "DBUS_SESSION_BUS_ADDRESS" = "unix:path=/run/user/1000/bus";
    };
    serviceConfig = {
      User = "aki";
      Type = "oneshot";
      ExecStart = "${pkgs.libnotify}/bin/notify-send -u critical -a 'NixOS Upgrade' -i nix-snowflake 'Upgrade Failed' 'Check the logs for more info'";
    };
  };

  nix.gc = {
    automatic = true;
    dates = "8:00";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "23.11";
}
