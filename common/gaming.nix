{ pkgs, ... }: {
  imports = [ ];

  networking.hosts = {
    "127.0.0.1" = [ "winter15.gosredirector.ea.com" ]; # A fix for "Mirrors Edge Catalyst". Without this it will try to ping a server that has been shutdown, then fail and crash
  };

  services.hardware.openrgb.enable = true;
  services.ratbagd.enable = true;
  services.libinput.mouse.accelProfile = "flat";

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
    protontricks.enable = true;
  };
  environment.systemPackages = with pkgs; [
    piper
    wine
    wine64
    winetricks
    protonplus
    r2modman
    prismlauncher
    lutris
  ];

  users.users.scarlett.packages = with pkgs; [
    heroic
  ];
}
