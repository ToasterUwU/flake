{
  pkgs,
  config,
  inputs,
  ...
}:
{
  age.secrets = {
    "aki-nixpkgs-review-github-token" = {
      file = ../secrets/common/aki-nixpkgs-review-github-token.age;
      mode = "700";
      owner = "aki";
      group = "users";
    };
    "aki-nixpkgs-update-github-token" = {
      file = ../secrets/common/aki-nixpkgs-update-github-token.age;
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
          profiles.default = {
            enableUpdateCheck = false;
            userSettings = {
              "catppuccin.accentColor" = "pink";
              "editor.semanticHighlighting.enabled" = true;
              "terminal.integrated.minimumContrastRatio" = 1;
              "window.titleBarStyle" = "custom";
              "workbench.colorTheme" = "Catppuccin Mocha";
              "files.autoSave" = "afterDelay";
              "git.enableSmartCommit" = true;
              "git.confirmSync" = false;
              "nix.enableLanguageServer" = true;
              "nix.serverPath" = "nil";
              "nix.formatterPath" = "nixfmt";
            };
          };
          package = pkgs.vscode.fhsWithPackages (
            ps: with ps; [
              craftos-pc
              nodejs_22
              nil
            ]
          );
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

  environment.systemPackages = with pkgs; [ godot_4 ];

  users.users.aki = {
    packages = with pkgs; [
      nil
      nixfmt-rfc-style
      (writeScriptBin "nixpkgs-review" ''
        #!/usr/bin/env bash

        export GITHUB_TOKEN=$(cat ${config.age.secrets."aki-nixpkgs-review-github-token".path})
        exec ${pkgs.nixpkgs-review}/bin/nixpkgs-review "$@"
      '')
      (writeScriptBin "nixpkgs-update" ''
        #!/usr/bin/env bash

        export GITHUB_TOKEN=$(cat ${config.age.secrets."aki-nixpkgs-update-github-token".path})
        exec ${inputs.nixpkgs-update.packages.x86_64-linux.default}/bin/nixpkgs-update "$@"
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
        extensions = [
          "rust-src"
          "rustfmt"
          "rustc-dev"
        ];
        targets = [
          "aarch64-unknown-linux-gnu"
          "x86_64-pc-windows-gnu"
          "x86_64-unknown-linux-gnu"
          "wasm32-unknown-unknown"
          "x86_64-apple-darwin"
          "aarch64-apple-darwin"
        ];
      })
      rust-analyzer

      nodejs

      python3
    ];
  };
}
