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
  };

  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations.Barbara = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hosts/Barbara
      ];

      specialArgs = { inherit inputs; };
    };
    nixosConfigurations.Gertrude = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hosts/Gertrude
      ];

      specialArgs = { inherit inputs; };
    };
  };
}
