{ pkgs, ... }: {
  imports = [ ];

  services.hardware.openrgb.enable = true;
  services.ratbagd.enable = true;
  services.libinput.mouse.accelProfile = "flat";

  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    piper
    wine64
    wineWowPackages.waylandFull
    winetricks
    protontricks
    r2modman
    prismlauncher
    lutris
  ];

  users.users.scarlett.packages = with pkgs; [
    heroic
  ];
}
