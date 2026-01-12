{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
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
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nix-gaming-edge = {
      url = "github:powerofthe69/nix-gaming-edge";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-patch-wayvr = {
      url = "https://github.com/NixOS/nixpkgs/pull/478553.diff";
      flake = false;
    };
    nixpkgs-patch-supersonic-update = {
      url = "https://github.com/NixOS/nixpkgs/pull/478892.diff";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-patcher,
      home-manager,
      catppuccin,
      agenix,
      arion,
      nixpkgs-xr,
      nix-gaming-edge,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations.Barbara = nixpkgs-patcher.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          agenix.nixosModules.default
          arion.nixosModules.arion
          nixpkgs-xr.nixosModules.nixpkgs-xr
          nix-gaming-edge.nixosModules.mesa-git
          ./hosts/Barbara
        ];

        specialArgs = inputs;
      };
      nixosConfigurations.Gertrude = nixpkgs-patcher.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          agenix.nixosModules.default
          arion.nixosModules.arion
          ./hosts/Gertrude
        ];

        specialArgs = inputs;
      };


      packages.x86_64-linux = {
        baballonia = pkgs.callPackage ./pkgs/baballonia { };
      };
    };
}
