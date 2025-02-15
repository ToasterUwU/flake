{ inputs, pkgs, config, ... }:
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

  services.monado = {
    enable = true;
    defaultRuntime = true;
  };

  systemd.user.services."monado".environment = {
    STEAMVR_LH_ENABLE = "true";
    XRT_COMPOSITOR_COMPUTE = "1";
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
      xdg.configFile."openxr/1/active_runtime.json".source = config.environment.etc."xdg/openxr/1/active_runtime.json".source;
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
      xdg.configFile."openxr/1/active_runtime.json".source = config.environment.etc."xdg/openxr/1/active_runtime.json".source;
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
