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

  environment.systemPackages = with pkgs; [
    wlx-overlay-s
    index_camera_passthrough
    envision
    BeatSaberModManager
  ];

  home-manager = {
    users.aki = {
      xdg.configFile."envision/envision.json".text = ''
        {"selected_profile_uuid": "ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1","debug_view_enabled": false,"user_profiles": [{"uuid": "ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1","name": "Custom","xrservice_type": "Monado","xrservice_path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/xrservice","xrservice_repo": "https://gitlab.freedesktop.org/BabbleBones/monado#vive_tracker3","xrservice_branch": null,"xrservice_cmake_flags": {},"opencomposite_path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/opencomposite","opencomposite_repo": "https://gitlab.com/BabbleBones/OpenOVR#htcx-fbt","opencomposite_branch": null,"features": {"libsurvive": {"feature_type": "Libsurvive","enabled": false,"path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/libsurvive","repo": null,"branch": null},"basalt": {"feature_type": "Basalt","enabled": false,"path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/basalt","repo": null,"branch": null},"openhmd": {"feature_type": "OpenHmd","enabled": false,"path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/openhmd","repo": null,"branch": null},"mercury_enabled": false},"environment": {"XRT_COMPOSITOR_SCALE_PERCENTAGE": "140","XRT_JSON_LOG": "1","XRT_COMPOSITOR_COMPUTE": "1","LD_LIBRARY_PATH": "/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib:/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib64","U_PACING_APP_USE_MIN_FRAME_PERIOD": "1","XRT_DEBUG_GUI": "1","XRT_CURATED_GUI": "1"},"prefix": "/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1","can_be_built": true,"editable": true,"pull_on_build": true,"lighthouse_driver": "SteamVR","xrservice_launch_options": "","autostart_command": "wlx-overlay-s"}],"win_size": [2560,1396]}
      '';
    };
    users.scarlett = {
      xdg.configFile."envision/envision.json".text = ''
        {"selected_profile_uuid": "ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1","debug_view_enabled": false,"user_profiles": [{"uuid": "ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1","name": "Custom","xrservice_type": "Monado","xrservice_path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/xrservice","xrservice_repo": "https://gitlab.freedesktop.org/BabbleBones/monado#vive_tracker3","xrservice_branch": null,"xrservice_cmake_flags": {},"opencomposite_path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/opencomposite","opencomposite_repo": "https://gitlab.com/BabbleBones/OpenOVR#htcx-fbt","opencomposite_branch": null,"features": {"libsurvive": {"feature_type": "Libsurvive","enabled": false,"path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/libsurvive","repo": null,"branch": null},"basalt": {"feature_type": "Basalt","enabled": false,"path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/basalt","repo": null,"branch": null},"openhmd": {"feature_type": "OpenHmd","enabled": false,"path": "/home/aki/.local/share/envision/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/openhmd","repo": null,"branch": null},"mercury_enabled": false},"environment": {"XRT_COMPOSITOR_SCALE_PERCENTAGE": "140","XRT_JSON_LOG": "1","XRT_COMPOSITOR_COMPUTE": "1","LD_LIBRARY_PATH": "/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib:/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1/lib64","U_PACING_APP_USE_MIN_FRAME_PERIOD": "1","XRT_DEBUG_GUI": "1","XRT_CURATED_GUI": "1"},"prefix": "/home/aki/.local/share/envision/prefixes/ce88bb0e-a05f-4de4-ad09-b2561b9b0ad1","can_be_built": true,"editable": true,"pull_on_build": true,"lighthouse_driver": "SteamVR","xrservice_launch_options": "","autostart_command": "wlx-overlay-s"}],"win_size": [2560,1396]}
      '';
    };
  };
}
