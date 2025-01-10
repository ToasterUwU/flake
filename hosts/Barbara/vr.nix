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
