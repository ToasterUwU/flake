{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.aki = {
      home.stateVersion = "23.11";
      programs.git = {
        enable = true;
        userName = "ToasterUwU";
        userEmail = "Aki@ToasterUwU.com";
      };
      programs.hyfetch = {
        enable = true;
        settings = {
          preset = "transgender";
          mode = "rgb";
          light_dark = "dark";
          lightness = 0.65;
          color_align = {
            mode = "horizontal";
            custom_colors = [ ];
            fore_back = null;
          };
          backend = "neofetch";
          distro = null;
          pride_month_shown = [ ];
        };
      };
      xdg.configFile."envision/envision.json".text = ''
        {"selected_profile_uuid": "ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1","debug_view_enabled": false,"user_profiles": [{"uuid": "ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1","name": "Custom","xrservice_type": "Monado","xrservice_path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/xrservice","xrservice_repo": "https://gitlab.freedesktop.org/BabbleBones/monado#vive_tracker3","xrservice_branch": null,"xrservice_cmake_flags": {},"opencomposite_path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/opencomposite","opencomposite_repo": "https://gitlab.com/BabbleBones/OpenOVR#htcx-fbt","opencomposite_branch": null,"features": {"libsurvive": {"feature_type": "Libsurvive","enabled": false,"path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/libsurvive","repo": null,"branch": null},"basalt": {"feature_type": "Basalt","enabled": false,"path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/basalt","repo": null,"branch": null},"openhmd": {"feature_type": "OpenHmd","enabled": false,"path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/openhmd","repo": null,"branch": null},"mercury_enabled": false},"environment": {"XRT_COMPOSITOR_SCALE_PERCENTAGE": "140","XRT_JSON_LOG": "1","XRT_COMPOSITOR_COMPUTE": "1","LD_LIBRARY_PATH": "/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib:/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib64","U_PACING_APP_USE_MIN_FRAME_PERIOD": "1","XRT_DEBUG_GUI": "1","XRT_CURATED_GUI": "1"},"prefix": "/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1","can_be_built": true,"editable": true,"pull_on_build": true,"lighthouse_driver": "SteamVR","xrservice_launch_options": "","autostart_command": "wlx-overlay-s"}],"win_size": [2560,1396]}
      '';
    };
    users.scarlett = {
      home.stateVersion = "23.11";
      programs.hyfetch = {
        enable = true;
        settings = {
          preset = "akiosexual";
          mode = "rgb";
          light_dark = "dark";
          lightness = 0.65;
          color_align = {
            mode = "horizontal";
            custom_colors = [ ];
            fore_back = null;
          };
          backend = "neofetch";
          distro = null;
          pride_month_shown = [ ];
        };
      };
      xdg.configFile."envision/envision.json".text = ''
        {"selected_profile_uuid": "ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1","debug_view_enabled": false,"user_profiles": [{"uuid": "ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1","name": "Custom","xrservice_type": "Monado","xrservice_path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/xrservice","xrservice_repo": "https://gitlab.freedesktop.org/BabbleBones/monado#vive_tracker3","xrservice_branch": null,"xrservice_cmake_flags": {},"opencomposite_path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/opencomposite","opencomposite_repo": "https://gitlab.com/BabbleBones/OpenOVR#htcx-fbt","opencomposite_branch": null,"features": {"libsurvive": {"feature_type": "Libsurvive","enabled": false,"path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/libsurvive","repo": null,"branch": null},"basalt": {"feature_type": "Basalt","enabled": false,"path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/basalt","repo": null,"branch": null},"openhmd": {"feature_type": "OpenHmd","enabled": false,"path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/openhmd","repo": null,"branch": null},"mercury_enabled": false},"environment": {"XRT_COMPOSITOR_SCALE_PERCENTAGE": "140","XRT_JSON_LOG": "1","XRT_COMPOSITOR_COMPUTE": "1","LD_LIBRARY_PATH": "/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib:/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib64","U_PACING_APP_USE_MIN_FRAME_PERIOD": "1","XRT_DEBUG_GUI": "1","XRT_CURATED_GUI": "1"},"prefix": "/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1","can_be_built": true,"editable": true,"pull_on_build": true,"lighthouse_driver": "SteamVR","xrservice_launch_options": "","autostart_command": "wlx-overlay-s"}],"win_size": [2560,1396]}
      '';
    };
  };
}
