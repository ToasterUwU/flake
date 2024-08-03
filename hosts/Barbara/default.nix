{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./vr.nix
    ../../common
    ../../common/optional/amd-gpu.nix
  ];
}
