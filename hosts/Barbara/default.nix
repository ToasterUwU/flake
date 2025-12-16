{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./vr.nix
    ./niri.nix
    ../../common
    ../../common/optional/amd-gpu.nix
  ];
}
