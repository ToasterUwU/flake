{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;

    users.aki = {
      home.stateVersion = "23.11";
      programs.hyfetch = {
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
      xdg.configFile."autostart/vesktop.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Vesktop
        Comment=Vesktop autostart script
        Exec=vesktop
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
    };
  };
}
