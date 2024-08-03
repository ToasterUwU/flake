{ ... }: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ../../common
    ../../common/optional/laptop.nix
  ];
}
