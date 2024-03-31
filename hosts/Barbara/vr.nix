{ inputs, pkgs, ... }: {
  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];

  environment.systemPackages = with pkgs; [
    wlx-overlay-s
    index_camera_passthrough
    envision
  ];
}
