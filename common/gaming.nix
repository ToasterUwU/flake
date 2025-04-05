{ pkgs, inputs, ... }:
let
  elfenermarcellPkgs = import inputs.nixpkgs-elfenermarcell { system = "x86_64-linux"; };
  jiriks74Pkgs = import inputs.nixpkgs-jiriks74 { system = "x86_64-linux"; };
  edmcPkgs = import inputs.nixpkgs-edmc { system = "x86_64-linux"; };
in
{
  imports = [ ];

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

  services.ananicy = {
    # https://github.com/NixOS/nixpkgs/issues/351516
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

  networking.hosts = {
    "127.0.0.1" = [ "winter15.gosredirector.ea.com" ]; # A fix for "Mirrors Edge Catalyst". Without this it will try to ping a server that has been shutdown, then fail and crash
  };

  home-manager.users = {
    aki = {
      imports = [ ../modules/home-manager/steam-game-launch-options ];
      programs.steam-launch-options = {
        enable = true;
        userId = "149816402";
        launchOptions = {
          "359320" =
            "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc OXR_PARALLEL_VIEWS=1 MinEdLauncher %command% /autorun /autoquit /edo /vr /restart 15"; # Elite Dangerous
          "2519830" =
            "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc OXR_PARALLEL_VIEWS=1 %command% -LoadAssembly Libraries/ResoniteModLoader.dll"; # Resonite
          "438100" = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%"; # VRChat
          "1292040" = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%"; # Stride
          "620980" = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%"; # Beat Saber
          "2441700" = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%"; # UNDERDOGS
          "1755100" = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%"; # The Last Clockwinder
          "1225570" = "for var in $(printenv | awk -F= 'length($2) > 2000 {print $1}'); do export $var=$(echo \${!var} | rev | cut -c 1-2000 | rev); done ; %command%"; # Unravel Two, EA Launcher Fix
          "1233570" = "for var in $(printenv | awk -F= 'length($2) > 2000 {print $1}'); do export $var=$(echo \${!var} | rev | cut -c 1-2000 | rev); done ; %command%"; # Mirror's Edge Catalyst, EA Launcher Fix
        };
      };
    };
  };
}
