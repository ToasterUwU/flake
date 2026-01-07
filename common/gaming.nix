{
  pkgs,
  lib,
  steam-config-nix,
  proton-cachyos,
  nix-cachyos-kernel,
  ...
}:
{
  nixpkgs.overlays = [
    proton-cachyos.overlays.default
    nix-cachyos-kernel.overlays.pinned
  ];

  # CachyOS Kernel Substituter
  nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];

  services.hardware.openrgb.enable = true;
  services.ratbagd.enable = true;
  services.libinput.mouse.accelProfile = "flat";

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      proton-cachyos-x86_64_v4
    ];
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
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  environment.systemPackages = with pkgs; [
    piper
    wine
    wine64
    winetricks
    protonplus
    gale
    prismlauncher
    lutris
    pcsx2
    ed-odyssey-materials-helper
    edmarketconnector
    min-ed-launcher
    pyfa
  ];

  networking.hosts = {
    # "127.0.0.1" = [ "winter15.gosredirector.ea.com" ]; # A fix for "Mirrors Edge Catalyst". Without this it will try to ping a server that has been shutdown, then fail and crash
  };

  home-manager = {
    sharedModules = [ steam-config-nix.homeModules.default ];
    users.aki = {
      xdg.configFile."min-ed-launcher/settings.json".text = ''
          {
            "apiUri": "https://api.zaonce.net",
            "watchForCrashes": false,
            "language": null,
            "autoUpdate": true,
            "checkForLauncherUpdates": true,
            "maxConcurrentDownloads": 4,
            "forceUpdate": "",
            "processes": [
              {
                "fileName": "${lib.getExe pkgs.ed-odyssey-materials-helper}",
                "keepOpen": true
              },
              {
                "fileName": "${lib.getExe pkgs.edmarketconnector}",
                "keepOpen": true
              },
              {
                "fileName": "${lib.getExe pkgs.steam}",
                "arguments": "steam://rungameid/12396075390739677184",
                "keepOpen": true
              }
            ],
            "shutdownProcesses": [],
            "filterOverrides": [
                { "sku": "FORC-FDEV-DO-1000", "filter": "edo" },
                { "sku": "FORC-FDEV-DO-38-IN-40", "filter": "edh4" }
            ],
            "additionalProducts": []
        }
      '';
      programs.steam.config = {
        enable = true;
        closeSteam = true;
        apps =
          let
            # Figures out the internal Proton CachyOS Proton name, the way steam expects it.
            cachyos-proton-name =
              (
                p:
                builtins.replaceStrings [ "x86_64_v4-" ] [ "" ] (
                  builtins.elemAt (builtins.match "^[^-]*-(.*)$" (baseNameOf (toString p))) 0
                )
              )
                (pkgs.proton-cachyos-x86_64_v4)
              + "-x86_64_v4";
          in
          {
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
              compatTool = cachyos-proton-name;
              launchOptions = {
                env = {
                  PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/monado_comp_ipc";
                };
                wrappers = [ "./run_monkeyloader.sh" ];
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
            rumble = {
              id = 890550;
              launchOptions = {
                env = {
                  PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/monado_comp_ipc";
                };
              };
            };
            myst = {
              id = 1255560;
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
