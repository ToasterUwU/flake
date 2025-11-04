{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "home-manager";
    };
    catppuccin.url = "github:catppuccin/nix";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    nixpkgs-update.url = "github:ryantm/nixpkgs-update";
    buttplug-lite = {
      url = "github:runtime-shady-backroom/buttplug-lite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
  };

  outputs =
    { nixpkgs, flake-utils, ... }@inputs:
    let
      shellPkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      devShells.x86_64-linux.default = shellPkgs.mkShell {
        buildInputs =
          with shellPkgs;
          [
            nixfmt-rfc-style
            nil
            python3
            python3Packages.vdf
          ]
          ++ [ inputs.agenix.packages.x86_64-linux.default ];
      };

      nixosConfigurations.Barbara = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/Barbara
          # inputs.niri.nixosModules.niri
          inputs.home-manager.nixosModules.home-manager
          inputs.catppuccin.nixosModules.catppuccin
          inputs.agenix.nixosModules.default
          inputs.arion.nixosModules.arion
          inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
        ];

        specialArgs = {
          inherit inputs;
        };
      };
      nixosConfigurations.Gertrude = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/Gertrude
          # inputs.niri.nixosModules.niri
          inputs.home-manager.nixosModules.home-manager
          inputs.catppuccin.nixosModules.catppuccin
          inputs.agenix.nixosModules.default
          inputs.arion.nixosModules.arion
        ];

        specialArgs = {
          inherit inputs;
        };
      };
    };
}
