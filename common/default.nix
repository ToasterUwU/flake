{ inputs, ... }: {
  imports = [
    ./dev-work.nix
    ./flatpak.nix
    ./plasma.nix
    ./configuration.nix
  ];
}
