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

  services.monado = {
    enable = true;
    package = pkgs.monado.overrideAttrs (prevAttrs: {
      patches = prevAttrs.patches or [ ] ++ [
        ../../assets/vr/patches/playspacer-mover-monado.patch
      ];
    });
    defaultRuntime = true;
  };

  environment.systemPackages = with pkgs; [
    (pkgs.opencomposite.overrideAttrs (prevAttrs: {
      patches = prevAttrs.patches or [ ] ++ [
        ../../assets/vr/patches/generic-vive-tracker-fbt-and-index-controller-grip-opencomposite.patch
      ];
    }))
    wlx-overlay-s
    index_camera_passthrough
    BeatSaberModManager
  ];

  home-manager = {
    users.aki = {
      xdg.desktopEntries."BeatSaberModManager" = {
        name = "BeatSaber ModManager";
        comment = "BeatSaber ModManager";
        type = "Application";
        exec = "BeatSaberModManager";
        terminal = false;
        startupNotify = true;
      };
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
    };
    users.scarlett = {
      xdg.desktopEntries."BeatSaberModManager" = {
        name = "BeatSaber ModManager";
        comment = "BeatSaber ModManager";
        type = "Application";
        exec = "BeatSaberModManager";
        terminal = false;
        startupNotify = true;
      };
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
    };
  };
}
