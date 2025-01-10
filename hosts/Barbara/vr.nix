{ inputs, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  boot.kernelPatches = [{
    name = "amdgpu-ignore-ctx-privileges";
    patch = pkgs.fetchpatch {
      name = "cap_sys_nice_begone.patch";
      url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
      hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
    };
  }];

  programs.envision.enable = true;
  environment.systemPackages = with pkgs; [
    wlx-overlay-s
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
              "xrservice_repo": "https://gitlab.freedesktop.org/Galister/monado#main",
              "xrservice_branch": null,
              "xrservice_cmake_flags": {},
              "opencomposite_path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/opencomposite",
              "opencomposite_repo": "https://gitlab.com/BabbleBones/OpenOVR#forsarah",
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
              "xrservice_repo": "https://gitlab.freedesktop.org/Galister/monado#main",
              "xrservice_branch": null,
              "xrservice_cmake_flags": {},
              "opencomposite_path": "/home/scarlett/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/opencomposite",
              "opencomposite_repo": "https://gitlab.com/BabbleBones/OpenOVR#forsarah",
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
