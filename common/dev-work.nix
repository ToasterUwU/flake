{ pkgs, config, ... }:
{
  age.secrets = {
    "aki-nixpkgs-review-github-token" = {
      file = ../secrets/common/aki-nixpkgs-review-github-token.age;
      mode = "700";
      owner = "aki";
      group = "users";
    };
  };


  home-manager = {
    users.aki = {
      programs = {
        git = {
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

        direnv = {
          enable = true;
          enableBashIntegration = true;
          nix-direnv.enable = true;
        };

        vscode = {
          enable = true;
          package = pkgs.vscode.fhsWithPackages (ps: with ps; [
            craftos-pc
            nodejs_22
          ]);
        };
      };
    };
    users.scarlett = {
      programs = {
        direnv = {
          enable = true;
          enableBashIntegration = true;
          nix-direnv.enable = true;
        };

        vscode = {
          enable = true;
          package = pkgs.vscode.fhsWithPackages (ps: with ps; [ ]);
        };
      };
    };
  };


  environment.systemPackages = with pkgs; [
    godot_4
  ];

  users.users.aki = {
    packages = with pkgs; [
      nil
      nixpkgs-fmt
      (writeScriptBin "nixpkgs-review" ''
        #!/usr/bin/env bash

        export GITHUB_TOKEN=$(cat ${config.age.secrets."aki-nixpkgs-review-github-token".path})
        exec ${pkgs.nixpkgs-review}/bin/nixpkgs-review "$@"
      '')

      openscad-lsp
      clang-tools

      zlib
      gcc
      glibc
      binutils
      gnumake
      pkg-config
      openssl.dev
      systemd.dev
      gtk3.dev

      (rust-bin.stable.latest.default.override {
        extensions = [ "rust-src" "rustfmt" "rustc-dev" ];
        targets = [ "aarch64-unknown-linux-gnu" "x86_64-pc-windows-gnu" "x86_64-unknown-linux-gnu" "wasm32-unknown-unknown" "x86_64-apple-darwin" "aarch64-apple-darwin" ];
      })
      rust-analyzer

      nodejs

      python311
      python311Packages.nodriver
    ];
  };
}
