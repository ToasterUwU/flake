{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./niri.nix
    ../../common
    ../../common/optional/amd-gpu.nix
  ];
}
