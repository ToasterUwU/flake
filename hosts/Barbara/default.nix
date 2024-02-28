{ inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./amd-gpu.nix
    ./vr.nix
    ../../common
  ];
}
