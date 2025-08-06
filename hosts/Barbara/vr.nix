{
  inputs,
  pkgs,
  ...
}:
let
  opencomposite = pkgs.opencomposite.overrideAttrs {
    src = pkgs.fetchFromGitLab {
      owner = "knah";
      repo = "OpenOVR";
      rev = "0815bcd70176968d657f96b72db5c0cc42ffbda8";
      fetchSubmodules = true;
      hash = "sha256-pEkqGCB59Wxa7GMfAxZIZdpqJEs41QyKz2ybh7eGIO0=";
    };
  };

  monado = pkgs.monado.overrideAttrs {
    src = pkgs.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "Supreeeme";
      repo = "monado";
      rev = "f9e3d49bb64bd95896ae1907e93f29f6332078c6";
      hash = "sha256-ehl12w2CdVormWiq8tC402IWasx4MU6zASmO9r+ZTmo=";
    };
  };
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../../pkgs/vr.nix
  ];

  # SteamVR async reprojection patch
  # boot.kernelPatches = [
  #   {
  #     name = "amdgpu-ignore-ctx-privileges";
  #     patch = pkgs.fetchpatch {
  #       name = "cap_sys_nice_begone.patch";
  #       url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
  #       hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
  #     };
  #   }
  # ];

  programs.steam = {
    extraCompatPackages = with pkgs; [ proton-ge-rtsp-bin ];
  };

  environment.systemPackages =
    with pkgs;
    [
      bs-manager
      eepyxr
      wlx-overlay-s
    ]
    ++ [ inputs.buttplug-lite.packages.x86_64-linux.default ];

  services.monado = {
    enable = true;
    defaultRuntime = true;
    highPriority = true;
    package = monado;
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
        "${monado}/share/openxr/1/openxr_monado.json";
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
            "${opencomposite}/lib/opencomposite",
            "/home/aki/.local/share/Steam/steamapps/common/SteamVR"
          ],
          "version" : 1
        }
      '';

      xdg.configFile."wlxoverlay/watch.yaml".text = ''
        width: 0.115

        size: [400, 200]

        elements:
          # batteries
          - type: BatteryList
            rect: [0, 5, 400, 30]
            corner_radius: 4
            font_size: 16
            fg_color: "#8bd5ca"
            fg_color_low: "#B06060"
            fg_color_charging: "#6080A0"
            num_devices: 9
            layout: Horizontal
            low_threshold: 33

          # background panel
          - type: Panel
            rect: [0, 30, 400, 130]
            corner_radius: 20
            bg_color: "#24273a"

          # local clock
          - type: Label
            rect: [13, 85, 200, 50]
            corner_radius: 4
            font_size: 46 # Use 32 for 12-hour time
            fg_color: "#cad3f5"
            source: Clock
            format: "%H:%M" # 23:59
            #format: "%I:%M %p" # 11:59 PM

          # local date
          - type: Label
            rect: [15, 125, 200, 20]
            corner_radius: 4
            font_size: 14
            fg_color: "#cad3f5"
            source: Clock
            format: "%x" # local date representation

          # local day-of-week
          - type: Label
            rect: [15, 145, 200, 50]
            corner_radius: 4
            font_size: 14
            fg_color: "#cad3f5"
            source: Clock
            format: "%A" # Tuesday
            #format: "%a" # Tue

          # Open eepyxr
          - type: Button
            rect: [187, 42, 73, 32]
            corner_radius: 4
            font_size: 14
            fg_color: "#cad3f5"
            bg_color: "#5b6078"
            text: "eep"
            click_down:
              - type: Exec
                command: ["eepyxr"]
          # Close eepyxr
          - type: Button
            rect: [264, 42, 73, 32]
            corner_radius: 4
            font_size: 14
            fg_color: "#cad3f5"
            bg_color: "#5b6078"
            text: "awak"
            click_down:
              - type: Exec
                command: ["pkill", "eepyxr"]

          # Open lovr-playspace
          - type: Button
            rect: [187, 79, 73, 32]
            corner_radius: 4
            font_size: 14
            fg_color: "#cad3f5"
            bg_color: "#5b6078"
            text: "caged"
            click_down:
              - type: Exec
                command: ["lovr-playspace"]
          # Close lovr-playspace
          - type: Button
            rect: [264, 79, 73, 32]
            corner_radius: 4
            font_size: 14
            fg_color: "#cad3f5"
            bg_color: "#5b6078"
            text: "free"
            click_down:
              - type: Exec
                command: ["pkill", "lovr"]

          # Previous track
          - type: Button
            rect: [187, 116, 73, 32]
            corner_radius: 4
            font_size: 14
            fg_color: "#cad3f5"
            bg_color: "#5b6078"
            text: "⏮️"
            click_down:
              - type: Exec
                command: ["playerctl", "previous"]
          # Next track
          - type: Button
            rect: [264, 116, 73, 32]
            corner_radius: 4
            font_size: 14
            fg_color: "#cad3f5"
            bg_color: "#5b6078"
            text: "⏭️"
            click_down:
              - type: Exec
                command: ["playerctl", "next"]

          ## Volume buttons
          # Vol+
          - type: Button
            rect: [355, 42, 30, 32]
            corner_radius: 4
            font_size: 13
            fg_color: "#cad3f5"
            bg_color: "#5b6078"
            text: "🔊"
            click_down:
              - type: Exec
                command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"]
          # Play/Pause
          - type: Button
            rect: [355, 79, 30, 32]
            corner_radius: 4
            font_size: 13
            fg_color: "#cad3f5"
            bg_color: "#5b6078"
            text: "⏯"
            click_down:
              - type: Exec
                command: ["playerctl", "play-pause"]
          # Vol-
          - type: Button
            rect: [355, 116, 30, 32]
            corner_radius: 4
            font_size: 13
            fg_color: "#cad3f5"
            bg_color: "#5b6078"
            text: "🔉"
            click_down:
              - type: Exec
                command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"]

          ## Bottom button row
          # Config button
          - type: Button
            rect: [2, 162, 26, 36]
            corner_radius: 4
            font_size: 15
            bg_color: "#c6a0f6"
            fg_color: "#24273a"
            text: "C"
            click_up: # destroy if exists, otherwise create
              - type: Window
                target: settings
                action: ShowUi # only triggers if not exists
              - type: Window
                target: settings
                action: Destroy # only triggers if exists since before current frame

          # Dashboard toggle button
          - type: Button
            rect: [32, 162, 48, 36]
            corner_radius: 4
            font_size: 15
            bg_color: "#2288FF"
            fg_color: "#24273a"
            text: "Dash"
            click_up:
              - type: WayVR
                action: ToggleDashboard

          # Keyboard button
          - type: Button
            rect: [84, 162, 48, 36]
            corner_radius: 4
            font_size: 15
            fg_color: "#24273a"
            bg_color: "#a6da95"
            text: Kbd
            click_up:
              - type: Overlay
                target: "kbd"
                action: ToggleVisible
            long_click_up:
              - type: Overlay
                target: "kbd"
                action: Reset
            right_up:
              - type: Overlay
                target: "kbd"
                action: ToggleImmovable
            middle_up:
              - type: Overlay
                target: "kbd"
                action: ToggleInteraction
            scroll_up:
              - type: Overlay
                target: "kbd"
                action:
                  Opacity: { delta: 0.025 }
            scroll_down:
              - type: Overlay
                target: "kbd"
                action:
                  Opacity: { delta: -0.025 }

          # bottom row, of keyboard + overlays
          - type: OverlayList
            rect: [134, 160, 266, 40]
            corner_radius: 4
            font_size: 15
            fg_color: "#cad3f5"
            bg_color: "#1e2030"
            layout: Horizontal
            click_up: ToggleVisible
            long_click_up: Reset
            right_up: ToggleImmovable
            middle_up: ToggleInteraction
            scroll_up:
              Opacity: { delta: 0.025 }
            scroll_down:
              Opacity: { delta: -0.025 }
      '';

      xdg.configFile."wlxoverlay/wayvr.yaml".text = ''
        dashboard:
          exec: "wayvr-dashboard"
          args: ""
          env: ["GDK_BACKEND=wayland"]
      '';

      xdg.configFile."wlxoverlay/conf.d/skybox.yaml".text = ''
        skybox_texture: ${../../assets/battlefront-2.dds}
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

      xdg.dataFile."lovr-playspace/fade_start.txt".text = ''
        0.1
      '';
      xdg.dataFile."lovr-playspace/fade_stop.txt".text = ''
        0.2
      '';
    };
  };
}
