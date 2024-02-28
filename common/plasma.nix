{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

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
  };
}
