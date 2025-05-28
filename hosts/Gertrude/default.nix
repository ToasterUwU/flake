{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ../../common
    ../../common/optional/amd-gpu.nix
  ];
}
