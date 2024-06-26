{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable";
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    envision = {
      url = "gitlab:Scrumplex/envision/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    scrumpkgs = {
      url = "github:Scrumplex/pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
  };

  outputs = { nixpkgs, agenix, catppuccin, nixos-cosmic, ... }@inputs: {
    nixosConfigurations.Barbara = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hosts/Barbara
        catppuccin.nixosModules.catppuccin
        agenix.nixosModules.default
        {
          nix.settings = {
            substituters = [ "https://cosmic.cachix.org/" ];
            trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
          };
        }
        nixos-cosmic.nixosModules.default
      ];

      specialArgs = { inherit inputs; };
    };
    nixosConfigurations.Gertrude = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hosts/Gertrude
        catppuccin.nixosModules.catppuccin
        agenix.nixosModules.default
        {
          nix.settings = {
            substituters = [ "https://cosmic.cachix.org/" ];
            trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
          };
        }
        nixos-cosmic.nixosModules.default
      ];

      specialArgs = { inherit inputs; };
    };
    nixosConfigurations.Waltraud = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hosts/Waltraud
        catppuccin.nixosModules.catppuccin
        agenix.nixosModules.default
        {
          nix.settings = {
            substituters = [ "https://cosmic.cachix.org/" ];
            trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
          };
        }
        nixos-cosmic.nixosModules.default
      ];

      specialArgs = { inherit inputs; };
    };
  };
}
