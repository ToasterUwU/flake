{ inputs, pkgs, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    users.aki = {
      programs.vscode = {
        enable = true;
        package = pkgs.vscode.fhsWithPackages (ps: with ps; [
          fira-code
          nil
          zlib
          gcc
          pkg-config
          rustup
          openssl.dev
          systemd.dev
        ]);
      };
    };
  };

  users.users.aki = {
    packages = with pkgs; [
      nixpkgs-fmt
      python3
      nodejs
    ];
  };
}
