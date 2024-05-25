{ inputs, pkgs, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    users.aki = {
      programs.git = {
        enable = true;
        package = pkgs.gitFull;

        userName = "ToasterUwU";
        userEmail = "Aki@ToasterUwU.com";

        lfs.enable = true;

        extraConfig = {
          init.defaultBranch = "main";

          # Thanks Scrumplex for showing me this from Scott! https://www.youtube.com/watch?v=aolI_Rz0ZqY
          rerere.enabled = true;
          core.fsmonitor = true;
        };
      };

      programs.vscode = {
        enable = true;
        package = pkgs.vscode.fhsWithPackages (ps: with ps; [
          zlib
          gcc
          glibc
          binutils
          gnumake
          pkg-config
          rustc
          cargo
          openssl.dev
          systemd.dev
        ]);
      };
    };
  };

  users.users.aki = {
    packages = with pkgs; [
      nil
      nixpkgs-fmt
      python3
      nodejs
    ];
  };
}
