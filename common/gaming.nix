{
  pkgs,
  inputs,
  lib,
  ...
}:
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
    package = pkgs.steam.override {
      extraProfile = ''
        unset TZ
      '';
    };
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
    sharedModules = [ inputs.steam-config-nix.homeModules.default ];
    users.aki = {
      programs.steam.config = {
        enable = true;
        closeSteam = true;
        apps = {
          elite-dangerous = {
            id = 359320;
            launchOptions = {
              env = {
                PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/monado_comp_ipc";
                VR_OVERRIDE = "${pkgs.opencomposite}/lib/opencomposite";
                OXR_PARALLEL_VIEWS = true;
              };
              wrappers = [ "${lib.getExe pkgs.min-ed-launcher}" ];
              args = [
                "/autorun"
                "/autoquit"
                "/edo"
                "/vr"
                "/restart"
                "15"
              ];
            };
          };
          resonite = {
            id = 2519830;
            compatTool = "GE-Proton-rtsp";
            launchOptions = {
              env = {
                PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/monado_comp_ipc";
              };
              wrappers = [ "./run_monkeyloader.sh" ];
              args = [
                "-Device SteamVR"
              ];
            };
          };
          vrchat = {
            id = 438100;
            compatTool = "GE-Proton-rtsp";
            launchOptions = {
              env = {
                PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/monado_comp_ipc";
              };
            };
          };
          stride = {
            id = 1292040;
            launchOptions = {
              env = {
                PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/monado_comp_ipc";
              };
            };
          };
          beat-saber = {
            id = 620980;
            launchOptions = {
              env = {
                PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/monado_comp_ipc";
              };
            };
          };
          underdogs = {
            id = 2441700;
            launchOptions = {
              env = {
                PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/monado_comp_ipc";
              };
            };
          };
          last-clockwinder = {
            id = 1755100;
            launchOptions = {
              env = {
                PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/monado_comp_ipc";
              };
            };
          };
          unravel-two = {
            id = 1225570;
            # EA Launcher Fix
            launchOptions = {
              extraConfig = ''
                for var in $(printenv | awk -F= 'length($2) > 2000 {print $1}');
                do
                  export $var=$(echo $\{!var} | rev | cut -c 1-2000 | rev);
                done
              '';
            };
          };
          mirrors-edge-catalyst = {
            id = 1233570;
            # EA Launcher Fix
            launchOptions = {
              extraConfig = ''
                for var in $(printenv | awk -F= 'length($2) > 2000 {print $1}');
                do
                  export $var=$(echo $\{!var} | rev | cut -c 1-2000 | rev);
                done
              '';
            };
          };
          burnout-paradise-remastered = {
            id = 1238080;
            # EA Launcher Fix
            launchOptions = {
              extraConfig = ''
                for var in $(printenv | awk -F= 'length($2) > 2000 {print $1}');
                do
                  export $var=$(echo $\{!var} | rev | cut -c 1-2000 | rev);
                done
              '';
            };
          };
          h3vr = {
            id = 450540;
            launchOptions = {
              extraConfig = ''
                for var in $(printenv | awk -F= 'length($2) > 2000 {print $1}');
                do
                  export $var=$(echo $\{!var} | rev | cut -c 1-2000 | rev);
                done
              '';
            };
          };
          space-engineers = {
            id = 244850;
            launchOptions = {
              args = [ "-useallavailablecores" ];
            };
          };
        };
      };
    };
  };
}
