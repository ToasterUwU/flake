{ inputs, pkgs, ... }: {
  imports = [
    inputs.nixpkgs-xr.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    wlx-overlay-s
    index_camera_passthrough
  ];
}
