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

  environment.systemPackages = with pkgs; [
    krename
    kdePackages.qtwebsockets
  ];

  home-manager = {
    sharedModules = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];

    users.aki = {
      programs.plasma = {
        enable = true;
        workspace = {
          clickItemTo = "select";
          theme = "breeze-dark";
          colorScheme = "BreezeDark";
          iconTheme = "Papirus-Dark";
        };

        kwin.titlebarButtons = {
          left = [ "on-all-desktops" "keep-above-windows" ];
          right = [ "minimize" "maximize" "close" ];
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
              "com.github.korapp.homeassistant"
              "org.kde.plasma.systemtray"
              "org.kde.plasma.digitalclock"
            ];
          }
        ];
      };
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
        workspace = {
          clickItemTo = "select";
          theme = "breeze-dark";
          colorScheme = "BreezeDark";
          iconTheme = "Papirus-Dark";
        };

        kwin.titlebarButtons = {
          left = [ "on-all-desktops" "keep-above-windows" ];
          right = [ "minimize" "maximize" "close" ];
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
                    "applications:brave.desktop"
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
