{ pkgs, ... }: {
  imports = [ ];

  users.users.aki = {
    packages = with pkgs; [
      fira-code
      vscode
      nil
      nixpkgs-fmt
      python3
      rustup
      nodejs
    ];
  };
}
