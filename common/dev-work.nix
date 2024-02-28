{ inputs, pkgs, ... }: {
  imports = [ ];

  users.users.aki = {
    packages = with pkgs; [
      fira-code
      vscode
      nixpkgs-fmt
    ];
  };
}
