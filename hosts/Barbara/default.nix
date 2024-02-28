{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix
    ./configuration.nix
    ./vr.nix
    ../../common/default.nix
    ../../common/amd-gpu.nix
  ];
}
