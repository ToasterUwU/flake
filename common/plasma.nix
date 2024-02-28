{ inputs, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];

    users.aki = {
      programs.plasma = {
        workspace = {
          clickItemTo = "select";
          tooltipDelay = 5;
          theme = "breeze-dark";
          colorScheme = "BreezeDark";
        };

        kwin.titlebarButtons = {
          left = [ "on-all-desktops" "keep-above-windows" ];
          right = [ "help" "minimize" "maximize" "close" ];
        };

        spectacle.shortcuts = {
          captureActiveWindow = "Meta+Print";
          captureCurrentMonitor = "Print";
          captureEntireDesktop = "Shift+Print";
          captureRectangularRegion = "Meta+Shift+S";
          captureWindowUnderCursor = "Meta+Ctrl+Print";
          launch = "Meta+S";
          launchWithoutCapturing = "Meta+Alt+S";
        };
      };
    };
  };
}
