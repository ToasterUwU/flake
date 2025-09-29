{ pkgs, inputs, ... }:
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

  programs.corectrl.enable = true;

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

  environment.systemPackages = with pkgs; [
    piper
    wine
    wine64
    winetricks
    protonplus
    r2modman
    prismlauncher
    lutris
    pcsx2
    ed-odyssey-materials-helper
    edmarketconnector
    min-ed-launcher
  ];

  networking.hosts = {
    # "127.0.0.1" = [ "winter15.gosredirector.ea.com" ]; # A fix for "Mirrors Edge Catalyst". Without this it will try to ping a server that has been shutdown, then fail and crash
  };

  home-manager = {
    sharedModules = [ inputs.steam-launch-options.homeManagerModules.steam-launch-options ];
    users.aki = {
      programs.steam-launch-options = {
        enable = true;
        userId = "149816402";
        launchOptions = {
          "359320" =
            "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc OXR_PARALLEL_VIEWS=1 VR_OVERRIDE=${pkgs.opencomposite}/lib/opencomposite MinEdLauncher %command% /autorun /autoquit /edo /vr /restart 15"; # Elite Dangerous
          "2519830" =
            "env -u TZ PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc OXR_PARALLEL_VIEWS=1 ./run_monkeyloader.sh %command%"; # Resonite
          "438100" = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%"; # VRChat
          "1292040" = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%"; # Stride
          "620980" = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%"; # Beat Saber
          "2441700" = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%"; # UNDERDOGS
          "1755100" = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%"; # The Last Clockwinder
          "1225570" =
            "for var in $(printenv | awk -F= 'length($2) > 2000 {print $1}'); do export $var=$(echo \${!var} | rev | cut -c 1-2000 | rev); done ; %command%"; # Unravel Two, EA Launcher Fix
          "1233570" =
            "for var in $(printenv | awk -F= 'length($2) > 2000 {print $1}'); do export $var=$(echo \${!var} | rev | cut -c 1-2000 | rev); done ; %command%"; # Mirror's Edge Catalyst, EA Launcher Fix
          "1238080" =
            "for var in $(printenv | awk -F= 'length($2) > 2000 {print $1}'); do export $var=$(echo \${!var} | rev | cut -c 1-2000 | rev); done ; %command%"; # Burnout Paradise Remastered, EA Launcher Fix
          "450540" = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%"; # H3VR
        };
      };
    };
  };
}
