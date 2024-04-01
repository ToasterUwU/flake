{ inputs, pkgs, config, lib, ... }:
let
  amdgpu-kernel-module = pkgs.callPackage ./amdgpu-kernel-module.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
in
{
  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];

  boot.extraModulePackages = (amdgpu-kernel-module.overrideAttrs (prev: {
    patches = (prev.patches or [ ]) ++ [ inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone.patch ];
  }));

  environment.systemPackages = with pkgs; [
    wlx-overlay-s
    index_camera_passthrough
    envision
  ];
}
