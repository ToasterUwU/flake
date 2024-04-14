{ inputs, pkgs, ... }: {
  imports = [ ];

  services.vscode-server.enable = true;

  users.users.aki = {
    packages = with pkgs; [
      fira-code
      vscode
      nixpkgs-fmt
      python3
      rustup
      nodejs
    ];
  };
}
