{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.aki = {
      home.stateVersion = "23.11";
      programs.git = {
        enable = true;
        userName = "ToasterUwU";
        userEmail = "Aki@ToasterUwU.com";
      };
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
          backend = "neofetch";
          distro = null;
          pride_month_shown = [ ];
        };
      };
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
          backend = "neofetch";
          distro = null;
          pride_month_shown = [ ];
        };
      };
    };
  };
}
