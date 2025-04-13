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
    steam-launch-options = {
      url = "github:ToasterUwU/steam-launch-options-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable-v3";
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
    nixpkgs-elfenermarcell.url = "github:elfenermarcell/nixpkgs/ed-odyssey-materials-helper";
    nixpkgs-jiriks74.url = "github:jiriks74/nixpkgs/add_min-ed-launcher";
    nixpkgs-edmc.url = "github:jiriks74/nixpkgs/add_EDMarketConnector";
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

        modules = [ ./hosts/Barbara ];

        specialArgs = {
          inherit inputs;
        };
      };
      nixosConfigurations.Rouge = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [ ./hosts/Rouge ];

        specialArgs = {
          inherit inputs;
        };
      };
      nixosConfigurations.Gertrude = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [ ./hosts/Gertrude ];

        specialArgs = {
          inherit inputs;
        };
      };
      nixosConfigurations.Waltraud = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [ ./hosts/Waltraud ];

        specialArgs = {
          inherit inputs;
        };
      };
    };
}
