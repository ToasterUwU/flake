{ inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ../../common
  ];
}
