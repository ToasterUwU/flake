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

  programs.envision.enable = true;
  environment.systemPackages = with pkgs; [
    wlx-overlay-s
    wayvr-dashboard
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
    XRT_COMPOSITOR_SCALE_PERCENTAGE = "140";
  };

  home-manager = {
    users.aki = {
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
      xdg.configFile."openxr/1/active_runtime.json".source =
        config.environment.etc."xdg/openxr/1/active_runtime.json".source;

      xdg.configFile."wlxoverlay/wayvr.yaml".text = ''
        version: 1

        run_compositor_at_start: false

        auto_hide: true
        auto_hide_delay: 750

        keyboard_repeat_delay: 200
        keyboard_repeat_rate: 50

        dashboard:
          exec: "wayvr_dashboard"
          args: ""
          env: ["GDK_BACKEND=wayland"]

        displays:
          Watch:
            width: 400
            height: 600
            scale: 0.4
            attach_to: "HandRight" # HandLeft, HandRight
            pos: [0.0, 0.0, 0.125]
            rotation: {axis: [1.0, 0.0, 0.0], angle: -45.0}
          Disp1:
            width: 640
            height: 480
            primary: true # Required if you want to attach external processes (not spawned by WayVR itself) without WAYVR_DISPLAY_NAME set
          Disp2:
            width: 1280
            height: 720
            scale: 2.0

        catalogs:
          default_catalog:
            apps:
              - name: "Calc"
                target_display: "Disp1"
                exec: "kcalc"
                shown_at_start: false

              - name: "btop"
                target_display: "Watch"
                exec: "konsole"
                args: "-e btop"

              - name: "Browser"
                target_display: "Disp2"
                exec: "firefox"
      '';
    };
    users.scarlett = {
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
      xdg.configFile."openxr/1/active_runtime.json".source =
        config.environment.etc."xdg/openxr/1/active_runtime.json".source;

      xdg.configFile."wlxoverlay/wayvr.yaml".text = ''
        version: 1

        run_compositor_at_start: false

        auto_hide: true
        auto_hide_delay: 750

        keyboard_repeat_delay: 200
        keyboard_repeat_rate: 50

        dashboard:
          exec: "wayvr_dashboard"
          args: ""
          env: ["GDK_BACKEND=wayland"]

        displays:
          Watch:
            width: 400
            height: 600
            scale: 0.4
            attach_to: "HandRight" # HandLeft, HandRight
            pos: [0.0, 0.0, 0.125]
            rotation: {axis: [1.0, 0.0, 0.0], angle: -45.0}
          Disp1:
            width: 640
            height: 480
            primary: true # Required if you want to attach external processes (not spawned by WayVR itself) without WAYVR_DISPLAY_NAME set
          Disp2:
            width: 1280
            height: 720
            scale: 2.0

        catalogs:
          default_catalog:
            apps:
              - name: "Calc"
                target_display: "Disp1"
                exec: "kcalc"
                shown_at_start: false

              - name: "btop"
                target_display: "Watch"
                exec: "konsole"
                args: "-e btop"

              - name: "Browser"
                target_display: "Disp2"
                exec: "firefox"
      '';
    };
  };
}
