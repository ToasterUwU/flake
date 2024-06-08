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
        package = pkgs.vscode-fhs;
      };
    };
  };

  users.users.aki = {
    packages = with pkgs; [
      nil
      nixpkgs-fmt
      nixpkgs-review
      openscad-lsp
      binutils
      gcc
      glibc
      zlib
      openssl.dev
      systemd.dev
      gnumake
      pkg-config
      clang-tools
      (rust-bin.stable.latest.default.override {
        extensions = [ "rust-src" "rustfmt" "rustc-dev" ];
        targets = [ "aarch64-unknown-linux-gnu" "x86_64-pc-windows-gnu" "x86_64-unknown-linux-gnu" "wasm32-unknown-unknown" "x86_64-apple-darwin" "aarch64-apple-darwin" ];
      })
      rust-analyzer
      python3
      nodejs
    ];
  };
}
