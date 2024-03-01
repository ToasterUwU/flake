{ inputs, pkgs, ... }: {
  imports = [ ];

  users.users.aki = {
    programs.steam.enable = true;
    packages = with pkgs; [
      winetricks
      protontricks
      prismlauncher-qt5
      protonup-qt
    ];
  };
}


