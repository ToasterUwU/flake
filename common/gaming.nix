{ inputs, pkgs, ... }: {
  imports = [ ];

  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    winetricks
    protontricks
    prismlauncher-qt5
    protonup-qt
  ];
}


