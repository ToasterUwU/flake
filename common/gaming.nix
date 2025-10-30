{ pkgs, inputs, ... }:
{
  imports = [ ];

  services.hardware.openrgb.enable = true;
  services.ratbagd.enable = true;
  services.libinput.mouse.accelProfile = "flat";

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

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
        defaultProton = "GE-Proton";
        gameOverrides = {
          "359320" = {
            # Elite Dangerous
            launchOptions = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc VR_OVERRIDE=${pkgs.opencomposite}/lib/opencomposite OXR_PARALLEL_VIEWS=1 MinEdLauncher %command% /autorun /autoquit /edo /vr /restart 15";
          };
          "2519830" = {
            # Resonite
            launchOptions = "env -u TZ PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc OXR_PARALLEL_VIEWS=1 ./run_monkeyloader.sh %command%";
            protonOverride = "GE-Proton-rtsp";
          };
          "438100" = {
            # VRChat
            launchOptions = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%";
            protonOverride = "GE-Proton-rtsp";
          };
          "1292040" = {
            # Stride
            launchOptions = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%";
          };
          "620980" = {
            # Beat Saber
            launchOptions = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%";
          };
          "2441700" = {
            # UNDERDOGS
            launchOptions = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%";
          };
          "1755100" = {
            # The Last Clockwinder
            launchOptions = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%";
          };
          "1225570" = {
            # Unravel Two, EA Launcher Fix
            launchOptions = "for var in $(printenv | awk -F= 'length($2) > 2000 {print $1}'); do export $var=$(echo \${!var} | rev | cut -c 1-2000 | rev); done ; %command%";
          };
          "1233570" = {
            # Mirror's Edge Catalyst, EA Launcher Fix
            launchOptions = "for var in $(printenv | awk -F= 'length($2) > 2000 {print $1}'); do export $var=$(echo \${!var} | rev | cut -c 1-2000 | rev); done ; %command%";
            protonOverride = "proton_8";
          };
          "1238080" = {
            # Burnout Paradise Remastered, EA Launcher Fix
            launchOptions = "for var in $(printenv | awk -F= 'length($2) > 2000 {print $1}'); do export $var=$(echo \${!var} | rev | cut -c 1-2000 | rev); done ; %command%";
          };
          "450540" = {
            # H3VR
            launchOptions = "env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%";
          };
          "244850" = {
            # Space Engineers
            launchOptions = "%command% -useallavailablecores";
          };
        };
      };
    };
  };
}
