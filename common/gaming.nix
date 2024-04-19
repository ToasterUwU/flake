{ pkgs, ... }: {
  imports = [ ];

  services.hardware.openrgb.enable = true;
  services.ratbagd.enable = true;

  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    piper
    wineWowPackages.waylandFull
    winetricks
    protontricks
    prismlauncher-qt5
  ];

  users.users.scarlett.packages = with pkgs; [
    heroic
  ];
}
