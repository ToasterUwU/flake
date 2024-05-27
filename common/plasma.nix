{ inputs, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  services = {
    xserver.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
      };
      defaultSession = "plasma";
    };
    desktopManager.plasma6.enable = true;
  };

  programs.kdeconnect.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
  ];

  environment.systemPackages = with pkgs; [
    krename
    kdePackages.kalk
  ];

  users.users =
    {
      aki = {
        packages = with pkgs; [
          (catppuccin-kde.override {
            flavour = [ "mocha" ];
            accents = [ "pink" ];
          })
          (catppuccin-papirus-folders.override {
            flavor = "mocha";
            accent = "pink";
          })
          catppuccin-cursors.mochaPink
        ];
      };
      scarlett = {
        packages = with pkgs; [
          (catppuccin-kde.override {
            flavour = [ "mocha" ];
            accents = [ "red" ];
          })
          (catppuccin-papirus-folders.override {
            flavor = "mocha";
            accent = "red";
          })
          catppuccin-cursors.mochaRed
        ];
      };
    };

  home-manager = {
    sharedModules = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];

    users.aki = {
      programs.plasma = {
        enable = true;
        overrideConfig = true;
        workspace = {
          clickItemTo = "select";
          theme = "catpuccin-mocha-pink";
          lookAndFeel = "Catppuccin-Mocha-Pink";
          colorScheme = "CatpuccinMochaPink";
          iconTheme = "Papirus-Dark";
          wallpaperSlideShow.path = ../wallpapers;
        };

        kwin.titlebarButtons = {
          left = [ "on-all-desktops" "keep-above-windows" ];
          right = [ "minimize" "maximize" "close" ];
        };

        configFile.kcminputrc = {
          Keyboard.NumLock.value = 0;
          Mouse.cursorTheme = "Catppuccin-Mocha-Pink-Cursors";
        };

        panels = [
          {
            location = "bottom";
            height = 40;
            floating = false;
            hiding = "normalpanel";
            widgets = [
              {
                name = "org.kde.plasma.kickoff";
                config = {
                  General.icon = "nix-snowflake";
                };
              }
              {
                name = "org.kde.plasma.icontasks";
                config = {
                  General.launchers = [
                    "applications:org.kde.konsole.desktop"
                    "applications:bitwarden.desktop"
                    "applications:org.kde.dolphin.desktop"
                    "applications:spotify.desktop"
                    "applications:firefox.desktop"
                    "applications:vesktop.desktop"
                    "applications:code-url-handler.desktop"
                    "applications:steam.desktop"
                  ];
                };
              }
              {
                name = "com.github.k-donn.plasmoid-wunderground";
                config = {
                  Station.stationID = "IWOLFS45";
                };
              }
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.systemtray"
              "org.kde.plasma.digitalclock"
            ];
          }
        ];
      };
      programs.konsole = {
        enable = true;
        defaultProfile = "Catppuccin";
        profiles.catppuccin = {
          name = "Catppuccin";
          colorScheme = "Catppuccin-Mocha";
        };
      };
      xdg.dataFile."konsole/Catppuccin-Mocha.colorscheme".source =
        pkgs.fetchFromGitHub
          {
            owner = "catppuccin";
            repo = "konsole";
            rev = "7d86b8a1e56e58f6b5649cdaac543a573ac194ca";
            sha256 = "EwSJMTxnaj2UlNJm1t6znnatfzgm1awIQQUF3VPfCTM=";
          }
        + "/Catppuccin-Mocha.colorscheme";
      xdg.dataFile."kio/servicemenus/krename.desktop".text = ''
        [Desktop Entry]
        Type=Service
        ServiceTypes=KonqPopupMenu/Plugin
        MimeType=all/all
        Actions=rename;
        X-KDE-Priority=TopLevel
        X-KDE-StartupNotify=false
        Icon=krename

        [Desktop Action rename]
        Name=Advanced Rename
        Name[it]=Rinomina: opzioni avanzate
        Icon=edit-rename
        Exec=krename %F
      '';
      xdg.dataFile."kio/servicemenus/openinvscode.desktop".text = ''
        [Desktop Entry]
        Name = Open In VScode
        Type=Service
        ServiceTypes=KonqPopupMenu/Plugin
        MimeType=all/all;
        X-KDE-Priority=TopLevel
        Actions = openvscode

        [Desktop Action openvscode]
        Name = Open In VSCode
        Exec=code %f
        Icon=visual-studio-code
      '';
    };
    users.scarlett = {
      programs.plasma = {
        enable = true;
        overrideConfig = true;
        workspace = {
          clickItemTo = "select";
          theme = "catpuccin-mocha-red";
          lookAndFeel = "Catppuccin-Mocha-Red";
          colorScheme = "CatpuccinMochaRed";
          iconTheme = "Papirus-Dark";
          cursorTheme = "Catppuccin-Mocha-Red-Cursors";
          wallpaper = ../wallpapers/red_nebula.jpg;
        };

        kwin.titlebarButtons = {
          left = [ "on-all-desktops" "keep-above-windows" ];
          right = [ "minimize" "maximize" "close" ];
        };

        configFile.kcminputrc = {
          Keyboard.NumLock.value = 0;
        };
        configFile.kxkbrc.Layout = {
          LayoutList = "gb";
          Use = true;
        };

        panels = [
          {
            location = "bottom";
            height = 40;
            floating = false;
            hiding = "normalpanel";
            widgets = [
              {
                name = "org.kde.plasma.kickoff";
                config = {
                  General.icon = "nix-snowflake";
                };
              }
              {
                name = "org.kde.plasma.icontasks";
                config = {
                  General.launchers = [
                    "applications:org.kde.dolphin.desktop"
                    "applications:vesktop.desktop"
                    "applications:brave-browser.desktop"
                    "applications:steam.desktop"
                  ];
                };
              }
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.systemtray"
              "org.kde.plasma.digitalclock"
            ];
          }
        ];
      };
      programs.konsole = {
        enable = true;
        defaultProfile = "Catppuccin";
        profiles.catppuccin = {
          name = "Catppuccin";
          colorScheme = "Catppuccin-Mocha";
        };
      };
      xdg.dataFile."konsole/Catppuccin-Mocha.colorscheme".source =
        pkgs.fetchFromGitHub
          {
            owner = "catppuccin";
            repo = "konsole";
            rev = "7d86b8a1e56e58f6b5649cdaac543a573ac194ca";
            sha256 = "EwSJMTxnaj2UlNJm1t6znnatfzgm1awIQQUF3VPfCTM=";
          }
        + "/Catppuccin-Mocha.colorscheme";
      xdg.dataFile."kio/servicemenus/krename.desktop".text = ''
        [Desktop Entry]
        Type=Service
        ServiceTypes=KonqPopupMenu/Plugin
        MimeType=all/all
        Actions=rename;
        X-KDE-Priority=TopLevel
        X-KDE-StartupNotify=false
        Icon=krename

        [Desktop Action rename]
        Name=Advanced Rename
        Name[it]=Rinomina: opzioni avanzate
        Icon=edit-rename
        Exec=krename %F
      '';
    };
  };
}
