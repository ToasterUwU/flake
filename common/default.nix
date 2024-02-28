{ inputs, ... }: {
  # You can import any NixOS modules here
  # Or you can just configure random stuff here too. The stage is yours!
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./dev-work.nix
  ];
}
