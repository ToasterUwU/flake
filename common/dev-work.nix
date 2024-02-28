{ inputs, ... }: {
  imports = [ ];

  users.users.aki = {
    packages = with pkgs; [
      vscode
      nixpkgs-fmt
    ];
  };
}
