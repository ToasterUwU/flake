{ pkgs, ... }: {
  imports = [ ];

  services.hardware.openrgb.enable = true;
  services.ratbagd.enable = true;
  services.libinput.mouse.accelProfile = "flat";

  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    piper
    wineWowPackages.waylandFull
    winetricks
    protontricks
    prismlauncher
    lutris
  ];

  users.users.scarlett.packages = with pkgs; [
    heroic
  ];
}
