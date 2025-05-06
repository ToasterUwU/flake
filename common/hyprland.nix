{ inputs, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    # withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  environment.systemPackages = with pkgs; [
    hyprlock
    hypridle
    hyprpaper
    hyprpicker
    hyprpolkitagent
  ];
}