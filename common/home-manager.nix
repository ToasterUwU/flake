{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.aki = {
      home.stateVersion = "23.11";
      xdg.configFile."hyfetch.json".text = ''
        {"preset": "transgender", "mode": "rgb", "light_dark": "dark", "lightness": 0.65, "color_align": {"mode": "horizontal", "custom_colors": [], "fore_back": null}, "backend": "neofetch", "distro": null, "pride_month_shown": []}
      '';
      programs.git = {
        enable = true;
        userName  = "ToasterUwU";
        userEmail = "Aki@ToasterUwU.com";
      };
    };
  };
}
