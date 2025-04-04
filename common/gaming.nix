{ pkgs, inputs, ... }:
let
  elfenermarcellPkgs = import inputs.nixpkgs-elfenermarcell { system = "x86_64-linux"; };
  jiriks74Pkgs = import inputs.nixpkgs-jiriks74 { system = "x86_64-linux"; };
  edmcPkgs = import inputs.nixpkgs-edmc { system = "x86_64-linux"; };
in
{
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

  services.ananicy = { # https://github.com/NixOS/nixpkgs/issues/351516
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-cpp;
    extraRules = [
      {
        "name" = "gamescope";
        "nice" = -20;
      }
    ];
  };

  environment.systemPackages =
    with pkgs;
    [
      piper
      wine
      wine64
      winetricks
      protonplus
      r2modman
      prismlauncher
      lutris
    ]
    ++ [
      elfenermarcellPkgs.ed-odyssey-materials-helper
      jiriks74Pkgs.min-ed-launcher
      edmcPkgs.edmarketconnector
    ];

  users.users.scarlett.packages = with pkgs; [ heroic ];
}
