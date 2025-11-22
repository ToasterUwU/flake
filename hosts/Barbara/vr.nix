{ inputs, pkgs, ... }:
let
  custom-monado = pkgs.monado.overrideAttrs (old: {
    src = pkgs.fetchgit {
      url = "https://tangled.org/@matrixfurry.com/monado";
      rev = "7877317b711e9b526954b97ba4ff41093143cdea";
      hash = "sha256-iwVshTy5bCwUII8/RAQDv5vSDV6qJ4cI/FTkmz/eje0=";
    };
  });

  custom-xrizer = pkgs.xrizer.overrideAttrs rec {
    src = pkgs.fetchFromGitHub {
      owner = "RinLovesYou";
      repo = "xrizer";
      rev = "f491eddd0d9839d85dbb773f61bd1096d5b004ef";
      hash = "sha256-12M7rkTMbIwNY56Jc36nC08owVSPOr1eBu0xpJxikdw=";
    };

    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-87JcULH1tAA487VwKVBmXhYTXCdMoYM3gOQTkM53ehE=";
    };

    patches = [ ];

    doCheck = false;
  };
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../../pkgs/vr.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bigscreen Beyond Kernel patches from LVRA Discord Thread
  boot.kernelPatches = [
    {
      name = "0001-drm-edid-parse-DRM-VESA-dsc-bpp-target";
      patch = ../../assets/kernel/0001-drm-edid-parse-DRM-VESA-dsc-bpp-target.patch;
    }
    {
      name = "0002-drm-amd-use-fixed-dsc-bits-per-pixel-from-edid";
      patch = ../../assets/kernel/0002-drm-amd-use-fixed-dsc-bits-per-pixel-from-edid.patch;
    }
  ];

  # Udev rules for Bigscreen devices
  services.udev.extraRules = ''
    # Bigscreen Beyond
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0101", MODE="0660", TAG+="uaccess"
    # Bigscreen Bigeye
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0202", MODE="0660", TAG+="uaccess", GROUP="users"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0202", MODE="0660", TAG+="uaccess", GROUP="users"
    # Bigscreen Beyond Audio Strap
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="0105", MODE="0660", TAG+="uaccess"
    # Bigscreen Beyond Firmware Mode?
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="35bd", ATTRS{idProduct}=="4004", MODE="0660", TAG+="uaccess"
  '';

  programs.steam = {
    extraCompatPackages = with pkgs; [ proton-ge-rtsp-bin ];
  };

  environment.systemPackages =
    with pkgs;
    [
      bs-manager
      eepyxr
      wlx-overlay-s
      lovr-playspace
      resolute
      lighthouse-steamvr
    ]
    ++ [ inputs.buttplug-lite.packages.x86_64-linux.default ];

  services.monado = {
    enable = true;
    defaultRuntime = true;
    highPriority = true;
    package = custom-monado;
  };

  systemd.user.services.monado = {
    serviceConfig.LimitNOFILE = 8192;
    environment = {
      STEAMVR_LH_ENABLE = "true";
      XRT_COMPOSITOR_COMPUTE = "1";
      XRT_COMPOSITOR_SCALE_PERCENTAGE = "100";
      XRT_COMPOSITOR_DESIRED_MODE = "0";
      # XRT_COMPOSITOR_DESIRED_MODE=0 is the 75hz mode
      # XRT_COMPOSITOR_DESIRED_MODE=1 is the 90hz mode
    };
  };

  home-manager = {
    users.aki = {
      xdg.configFile."openxr/1/active_runtime.json".source =
        "${custom-monado}/share/openxr/1/openxr_monado.json";
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
            "${custom-xrizer}/lib/xrizer",
            "/home/aki/.local/share/Steam/steamapps/common/SteamVR"
          ],
          "version" : 1
        }
      '';

      xdg.configFile."wlxoverlay/conf.d/zz-saved-config.json5".text = ''
        {
          "watch_pos": [
            -0.059999954,
            -0.022,
            0.1760001
          ],
          "watch_rot": [
            -0.6760993,
            0.11002616,
            0.707073,
            -0.17551248
          ],
          "watch_hand": "Left",
          "watch_view_angle_min": 0.5,
          "watch_view_angle_max": 0.7,
          "notifications_enabled": true,
          "notifications_sound_enabled": true,
          "realign_on_showhide": true,
          "allow_sliding": true,
          "space_drag_multiplier": 1.0,
          "block_game_input": true
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

      xdg.dataFile."LOVR/lovr-playspace/fade_start.txt".text = ''
        0.1
      '';
      xdg.dataFile."LOVR/lovr-playspace/fade_stop.txt".text = ''
        0.3
      '';
    };
  };
}
