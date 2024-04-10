{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  services = {
    xserver =
      {
        enable = true;
        displayManager = {
          sddm = {
            enable = true;
            autoNumlock = true;
          };
          defaultSession = "plasma";
        };
      };
    desktopManager.plasma6.enable = true;
  };


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
      };
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
      };
    };
  };
}
