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
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs }@inputs: {
    nixosConfigurations.Barbara = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        # you could also import stuff here, but I prefer to do it in my purpose.nix files
        ./hosts/Barbara/default.nix
      ];

      specialArgs = { inherit inputs; };
    };
  };
}
