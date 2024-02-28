{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix
    ./configuration.nix
    ./amd-gpu.nix
    ./vr.nix
    ../../common
  ];
}
