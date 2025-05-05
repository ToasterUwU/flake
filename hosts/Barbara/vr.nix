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

  environment.systemPackages = with pkgs; [
    bs-manager
    vrcx
  ];

  services.monado = {
    enable = true;
    defaultRuntime = true;
    highPriority = true;
  };

  systemd.user.services."monado".environment = {
    STEAMVR_LH_ENABLE = "true";
    XRT_COMPOSITOR_COMPUTE = "1";
    XRT_COMPOSITOR_SCALE_PERCENTAGE = "250";
    XRT_COMPOSITOR_DESIRED_MODE = "2"; # Valve Index: 0=90hz 1=80hz 2=120hz 3=144hz (default=4)
    U_PACING_COMP_MIN_TIME_MS = "3";
  };

  home-manager = {
    users.aki = {
      xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
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
    users.scarlett = {
      xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
      xdg.configFile."openvr/openvrpaths.vrpath".text = ''
        {
          "config" :
          [
            "/home/scarlett/.local/share/Steam/config"
          ],
          "external_drivers" : null,
          "jsonid" : "vrpathreg",
          "log" :
          [
            "/home/scarlett/.local/share/Steam/logs"
          ],
          "runtime" :
          [
            "${pkgs.opencomposite}/lib/opencomposite",
            "/home/scarlett/.local/share/Steam/steamapps/common/SteamVR"
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
        toggle_button = "Menu"
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
