{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [
      inputs.catppuccin.homeManagerModules.catppuccin
    ];

    users.aki = {
      home.stateVersion = "23.11";
      gtk = {
        enable = true;
        catppuccin.enable = true;
      };
      programs = {
        hyfetch = {
          enable = true;
          settings = {
            preset = "transgender";
            mode = "rgb";
            light_dark = "dark";
            lightness = 0.65;
            color_align = {
              mode = "horizontal";
              custom_colors = [ ];
              fore_back = null;
            };
            backend = "fastfetch";
            distro = null;
            pride_month_shown = [ ];
          };
        };
        starship = {
          enable = true;
          enableBashIntegration = true;
          catppuccin.enable = true;
          settings = {
            directory = {
              truncation_length = 12;
              truncate_to_repo = false;
              truncation_symbol = "…/";
            };
          };
        };
        zoxide = {
          enable = true;
          enableBashIntegration = true;
          options = [
            "--cmd cd"
          ];
        };
        bash = {
          enable = true;
          bashrcExtra = ''
            hyfetch
          '';
        };
        tealdeer = {
          enable = true;
          settings.updates = {
            auto_update = true;
            auto_update_interval_hours = 24;
          };
        };
        bat = {
          enable = true;
          catppuccin.enable = true;
        };
        bottom = {
          enable = true;
          catppuccin.enable = true;
        };
      };
      xdg.configFile."autostart/vesktop.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Vesktop
        Comment=Vesktop autostart script
        Exec=vesktop
        StartupNotify=false
        Terminal=false
      '';
      xdg.configFile."autostart/vdhcoapp-install.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Vdhcoapp Install
        Exec=vdhcoapp install
        StartupNotify=false
        Terminal=false
      '';
    };
    users.scarlett = {
      home.stateVersion = "23.11";
      programs.hyfetch = {
        enable = true;
        settings = {
          preset = "akiosexual";
          mode = "rgb";
          light_dark = "dark";
          lightness = 0.65;
          color_align = {
            mode = "horizontal";
            custom_colors = [ ];
            fore_back = null;
          };
          backend = "fastfetch";
          distro = null;
          pride_month_shown = [ ];
        };
      };
      xdg.configFile."autostart/vesktop.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Vesktop
        Comment=Vesktop autostart script
        Exec=vesktop
        StartupNotify=false
        Terminal=false
      '';
      xdg.configFile."autostart/brave-browser.desktop".text = ''
        [Desktop Entry]
        Version=1.0
        Name=Brave Web Browser
        Exec=brave %U
        StartupNotify=true
        Terminal=false
        Icon=brave-browser
        Type=Application
        Categories=Network;WebBrowser;
      '';
      xdg.configFile."autostart/steam.desktop".text = ''
        [Desktop Entry]
        Name=Steam
        Exec=steam %U
        Icon=steam
        Terminal=false
        Type=Application
        PrefersNonDefaultGPU=true
        X-KDE-RunOnDiscreteGpu=true
      '';
      xdg.configFile."autostart/vdhcoapp-install.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Vdhcoapp Install
        Exec=vdhcoapp install
        StartupNotify=false
        Terminal=false
      '';
    };
  };
}
