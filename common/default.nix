{ inputs, ... }: {
  imports = [
    ./dev-work.nix
    ./flatpak.nix
    ./home-manager.nix
    ./plasma.nix
    ./configuration.nix
  ];
}
