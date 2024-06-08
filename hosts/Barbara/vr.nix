{ inputs, pkgs, config, ... }:
let
  amdgpu-kernel-module = pkgs.callPackage ./amdgpu-kernel-module.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
in
{
  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    inputs.home-manager.nixosModules.home-manager
  ];

  boot.extraModulePackages = [
    (amdgpu-kernel-module.overrideAttrs (prev: {
      patches = (prev.patches or [ ]) ++ [ inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone.patch ];
    }))
  ];

  nixpkgs.overlays = [
    (final: prev: {
      wlx-overlay-s = prev.wlx-overlay-s.overrideAttrs {
        src = final.fetchFromGitHub {
          owner = "RinLovesYou";
          repo = "wlx-overlay-s";
          rev = "48666b8ecfacbccd1d2bc0300bce2f06ff49d681";
          hash = "sha256-idg/1R5dkv+81EyT82t3JQOfpbONcRt+TowFUofIoVY=";
        };
        cargoDeps = final.rustPlatform.importCargoLock {
          lockFile = ../../assets/wlx-overlay-s-Cargo.lock;
          outputHashes = {
            "wlx-capture-0.3.8" = "sha256-cbu5tmeGOHKd6BryjK509GuiBPUEhsaS/6mW92nRbO0=";
            "vulkano-0.34.0" = "sha256-0ZIxU2oItT35IFnS0YTVNmM775x21gXOvaahg/B9sj8=";
            "ovr_overlay-0.0.0" = "sha256-b2sGzBOB2aNNJ0dsDBjgV2jH3ROO/Cdu8AIHPSXMCPg=";
          };
        };
      };
    })
  ];

  environment.systemPackages = with pkgs; [
    wlx-overlay-s
    index_camera_passthrough
    envision
    BeatSaberModManager
  ];

  home-manager = {
    users.aki = {
      xdg.configFile."envision/envision.json".text = ''
        {
          "selected_profile_uuid": "ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1",
          "debug_view_enabled": false,
          "user_profiles": [
            {
              "uuid": "ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1",
              "name": "Custom",
              "xrservice_type": "Monado",
              "xrservice_path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/xrservice",
              "xrservice_repo": "https://gitlab.freedesktop.org/ToasterUwU/monado#vive_tracker3",
              "xrservice_branch": null,
              "xrservice_cmake_flags": {},
              "opencomposite_path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/opencomposite",
              "opencomposite_repo": "https://gitlab.com/BabbleBones/OpenOVR#htcx-fbt",
              "opencomposite_branch": null,
              "features": {
                "libsurvive": {
                  "feature_type": "Libsurvive",
                  "enabled": false,
                  "path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/libsurvive",
                  "repo": null,
                  "branch": null
                },
                "basalt": {
                  "feature_type": "Basalt",
                  "enabled": false,
                  "path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/basalt",
                  "repo": null,
                  "branch": null
                },
                "openhmd": {
                  "feature_type": "OpenHmd",
                  "enabled": false,
                  "path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/openhmd",
                  "repo": null,
                  "branch": null
                },
                "mercury_enabled": false
              },
              "environment": {
                "XRT_COMPOSITOR_SCALE_PERCENTAGE": "140",
                "XRT_JSON_LOG": "1",
                "XRT_COMPOSITOR_COMPUTE": "1",
                "LD_LIBRARY_PATH": "/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib:/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib64",
                "U_PACING_APP_USE_MIN_FRAME_PERIOD": "1",
                "XRT_DEBUG_GUI": "1",
                "XRT_CURATED_GUI": "1"
              },
              "prefix": "/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1",
              "can_be_built": true,
              "editable": true,
              "pull_on_build": true,
              "lighthouse_driver": "SteamVR",
              "xrservice_launch_options": "",
              "autostart_command": "LIBMONADO_PATH=\"/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib64/libmonado.so\" wlx-overlay-s"
            }
          ],
          "win_size": [
            2560,
            1396
          ]
        }
      '';
      xdg.desktopEntries."BeatSaberModManager" = {
        name = "BeatSaber ModManager";
        comment = "BeatSaber ModManager";
        type = "Application";
        exec = "BeatSaberModManager";
        terminal = false;
        startupNotify = true;
      };
    };
    users.scarlett = {
      xdg.configFile."envision/envision.json".text = ''
        {
          "selected_profile_uuid": "ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1",
          "debug_view_enabled": false,
          "user_profiles": [
            {
              "uuid": "ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1",
              "name": "Custom",
              "xrservice_type": "Monado",
              "xrservice_path": "/home/scarlett/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/xrservice",
              "xrservice_repo": "https://gitlab.freedesktop.org/ToasterUwU/monado#vive_tracker3",
              "xrservice_branch": null,
              "xrservice_cmake_flags": {},
              "opencomposite_path": "/home/scarlett/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/opencomposite",
              "opencomposite_repo": "https://gitlab.com/BabbleBones/OpenOVR#htcx-fbt",
              "opencomposite_branch": null,
              "features": {
                "libsurvive": {
                  "feature_type": "Libsurvive",
                  "enabled": false,
                  "path": "/home/scarlett/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/libsurvive",
                  "repo": null,
                  "branch": null
                },
                "basalt": {
                  "feature_type": "Basalt",
                  "enabled": false,
                  "path": "/home/scarlett/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/basalt",
                  "repo": null,
                  "branch": null
                },
                "openhmd": {
                  "feature_type": "OpenHmd",
                  "enabled": false,
                  "path": "/home/scarlett/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/openhmd",
                  "repo": null,
                  "branch": null
                },
                "mercury_enabled": false
              },
              "environment": {
                "XRT_COMPOSITOR_SCALE_PERCENTAGE": "140",
                "XRT_JSON_LOG": "1",
                "XRT_COMPOSITOR_COMPUTE": "1",
                "LD_LIBRARY_PATH": "/home/scarlett/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib:/home/scarlett/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib64",
                "U_PACING_APP_USE_MIN_FRAME_PERIOD": "1",
                "XRT_DEBUG_GUI": "1",
                "XRT_CURATED_GUI": "1"
              },
              "prefix": "/home/scarlett/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1",
              "can_be_built": true,
              "editable": true,
              "pull_on_build": true,
              "lighthouse_driver": "SteamVR",
              "xrservice_launch_options": "",
              "autostart_command": "LIBMONADO_PATH=\"/home/scarlett/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib64/libmonado.so\" wlx-overlay-s"
            }
          ],
          "win_size": [
            2560,
            1396
          ]
        }
      '';
      xdg.desktopEntries."BeatSaberModManager" = {
        name = "BeatSaber ModManager";
        comment = "BeatSaber ModManager";
        type = "Application";
        exec = "BeatSaberModManager";
        terminal = false;
        startupNotify = true;
      };
    };
  };
}
