{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../../pkgs/vr.nix
  ];

  programs.steam = {
    extraCompatPackages = with pkgs; [ proton-ge-rtsp-bin ];
  };

  environment.systemPackages =
    with pkgs;
    [
    bs-manager
    vrcx
    ]
    ++ [ inputs.buttplug-lite.packages.x86_64-linux.default ];

  services.monado = {
    enable = true;
    defaultRuntime = true;
    highPriority = true;
  };

  systemd.user.services."monado".environment = {
    STEAMVR_LH_ENABLE = "true";
    XRT_COMPOSITOR_COMPUTE = "1";
    XRT_COMPOSITOR_SCALE_PERCENTAGE = "200";
    XRT_COMPOSITOR_DESIRED_MODE = "2";
    # 0: 2880x1600@90.00 1: 2880x1600@144.00 2: 2880x1600@120.02 3: 2880x1600@80.00 4: 1920x1200@90.00
    # 5: 1920x1080@90.00 6: 1600x1200@90.00 7: 1680x1050@90.00 8: 1280x1024@90.00 9: 1440x900@90.00
    # 10: 1280x800@90.00 11: 1280x720@90.00 12: 1024x768@90.00 13: 800x600@90.00 14: 640x480@90.00
  };

  home-manager = {
    users.aki = {
      xdg.configFile."openxr/1/active_runtime.json".source =
        "${pkgs.monado}/share/openxr/1/openxr_monado.json";
      xdg.configFile."openvr/openvrpaths.vrpath".text = ''
        {
          "config" :
          [
            "/home/aki/.local/share/Steam/config"
          ],
          "external_drivers" : null,
          "jsonid" : "vrpathreg",
          "log" :
          [
            "/home/aki/.local/share/Steam/logs"
          ],
          "runtime" :
          [
            "${pkgs.opencomposite}/lib/opencomposite",
            "/home/aki/.local/share/Steam/steamapps/common/SteamVR"
          ],
          "version" : 1
        }
      '';

      xdg.configFile."wlxoverlay/wayvr.yaml".text = ''
        dashboard:
          exec: "wayvr-dashboard"
          args: ""
          env: ["GDK_BACKEND=wayland"]
      '';

      xdg.configFile."index_camera_passthrough/index_camera_passthrough.toml".text = ''
        backend="openxr"
        open_delay = "0s"

        [overlay.position]
        mode = "Hmd"
        distance = 0.7

        [display_mode]
        mode = "Stereo"
        projection_mode = "FromEye"
      '';
    };
  };
}
