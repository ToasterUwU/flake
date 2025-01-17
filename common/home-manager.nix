{ inputs, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  age.secrets = {
    "aki-id_ed25519" = {
      file = ../secrets/common/aki-id_ed25519.age;
      path = "/home/aki/.ssh/id_ed25519";
      owner = "aki";
      group = "users";
      mode = "600";
    };
    "aki-id_ed25519.pub" = {
      file = ../secrets/common/aki-id_ed25519.pub.age;
      path = "/home/aki/.ssh/id_ed25519.pub";
      owner = "aki";
      group = "users";
      mode = "644";
    };

    "scarlett-id_ed25519" = {
      file = ../secrets/common/scarlett-id_ed25519.age;
      path = "/home/scarlett/.ssh/id_ed25519";
      owner = "scarlett";
      group = "users";
      mode = "600";
    };
    "scarlett-id_ed25519.pub" = {
      file = ../secrets/common/scarlett-id_ed25519.pub.age;
      path = "/home/scarlett/.ssh/id_ed25519.pub";
      owner = "scarlett";
      group = "users";
      mode = "644";
    };

    "aki-.wakatime.cfg" = {
      file = ../secrets/common/aki-.wakatime.cfg.age;
      path = "/home/aki/.wakatime.cfg";
      owner = "aki";
      group = "users";
      mode = "600";
    };
  };

  system.userActivationScripts = {
    removeConflictingFiles = {
      text = ''
        for dir in /home/*; do
          if [ -d "$dir" ]; then
            FILE_PATH="$dir/.gtkrc-2.0.backup"
            if [ -e "$FILE_PATH" ]; then
              rm -f "$FILE_PATH"
              echo "File $FILE_PATH has been deleted."
            fi

            FILE_PATH="$dir/.config/gtk-4.0/gtk.css.backup"
            if [ -e "$FILE_PATH" ]; then
              rm -f "$FILE_PATH"
              echo "File $FILE_PATH has been deleted."
            fi

            FILE_PATH="$dir/.config/fontconfig/conf.d/10-hm-fonts.conf.backup"
            if [ -e "$FILE_PATH" ]; then
              rm -f "$FILE_PATH"
              echo "File $FILE_PATH has been deleted."
            fi
          fi
        done
      '';
    };
  };

  programs.fuse.userAllowOther = true;

  # Fix for FHS wrapped software thinking the permissions and ownership of the ssh config are mangled
  nixpkgs.overlays = [
    (final: prev: {
      openssh = prev.openssh.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ../assets/openssh-nocheckcfg.patch ];
        doCheck = false;
      });
    })
  ];

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [
      inputs.catppuccin.homeManagerModules.catppuccin
      inputs.spicetify-nix.homeManagerModules.default
    ];

    users.aki = {
      home.stateVersion = "23.11";

      systemd.user.services."sshfs-aki-home" = {
        Unit = {
          Description = "SSHFS Mount for Akis Home";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Service = {
          ExecStart = "${pkgs.sshfs}/bin/sshfs -f -o delay_connect,reconnect,ServerAliveInterval=10,ServerAliveCountMax=2,_netdev,user,transform_symlinks,IdentityFile=/home/aki/.ssh/id_ed25519,allow_other,default_permissions,uid=1000,gid=100,exec Aki@toasteruwu.com:/home /home/aki/NAS/home";
          ExecStop = "${pkgs.fuse}/bin/fusermount -u /home/aki/NAS/home";
          Restart = "on-failure";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/aki/NAS/home";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
      systemd.user.services."sshfs-aki-data" = {
        Unit = {
          Description = "SSHFS Mount for /data";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Service = {
          ExecStart = "${pkgs.sshfs}/bin/sshfs -f -o delay_connect,reconnect,ServerAliveInterval=10,ServerAliveCountMax=2,_netdev,user,transform_symlinks,IdentityFile=/home/aki/.ssh/id_ed25519,allow_other,default_permissions,uid=1000,gid=100,exec Aki@toasteruwu.com:/data /home/aki/NAS/data";
          ExecStop = "${pkgs.fuse}/bin/fusermount -u /home/aki/NAS/data";
          Restart = "on-failure";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/aki/NAS/data";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
      systemd.user.services."sshfs-aki-backups" = {
        Unit = {
          Description = "SSHFS Mount for /backups";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Service = {
          ExecStart = "${pkgs.sshfs}/bin/sshfs -f -o delay_connect,reconnect,ServerAliveInterval=10,ServerAliveCountMax=2,_netdev,user,transform_symlinks,IdentityFile=/home/aki/.ssh/id_ed25519,allow_other,default_permissions,uid=1000,gid=100,exec Aki@toasteruwu.com:/backups /home/aki/NAS/backups";
          ExecStop = "${pkgs.fuse}/bin/fusermount -u /home/aki/NAS/backups";
          Restart = "on-failure";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/aki/NAS/backups";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
      systemd.user.services."sshfs-aki-web" = {
        Unit = {
          Description = "SSHFS Mount for /web";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Service = {
          ExecStart = "${pkgs.sshfs}/bin/sshfs -f -o delay_connect,reconnect,ServerAliveInterval=10,ServerAliveCountMax=2,_netdev,user,transform_symlinks,IdentityFile=/home/aki/.ssh/id_ed25519,allow_other,default_permissions,uid=1000,gid=100,exec Aki@toasteruwu.com:/web /home/aki/NAS/web";
          ExecStop = "${pkgs.fuse}/bin/fusermount -u /home/aki/NAS/web";
          Restart = "on-failure";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/aki/NAS/web";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
      systemd.user.services."sshfs-aki-docker" = {
        Unit = {
          Description = "SSHFS Mount for /docker";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Service = {
          ExecStart = "${pkgs.sshfs}/bin/sshfs -f -o delay_connect,reconnect,ServerAliveInterval=10,ServerAliveCountMax=2,_netdev,user,transform_symlinks,IdentityFile=/home/aki/.ssh/id_ed25519,allow_other,default_permissions,uid=1000,gid=100,exec Aki@toasteruwu.com:/docker /home/aki/NAS/docker";
          ExecStop = "${pkgs.fuse}/bin/fusermount -u /home/aki/NAS/docker";
          Restart = "on-failure";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/aki/NAS/docker";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      xdg.mimeApps = {
        enable = true;
        associations.added = {
          "application/x-extension-htm" = "firefox.desktop";
          "application/x-extension-html" = "firefox.desktop";
          "application/x-extension-shtml" = "firefox.desktop";
          "application/x-extension-xht" = "firefox.desktop";
          "application/x-extension-xhtml" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";
          "text/html" = "firefox.desktop";
          "x-scheme-handler/chrome" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "model/stl" = "com.ultimaker.cura.desktop";
          "model/3mf" = "com.ultimaker.cura.desktop";
          "text/x.gcode" = "com.ultimaker.cura.desktop";
          "application/x-shellscript" = "code.desktop";
          "application/vhd.microsoft.portable-executable" = "wine.desktop";
        };
        defaultApplications = {
          "application/x-ms-dos-executable" = "wine.desktop";
          "application/x-msi" = "wine.desktop";
          "application/x-ms-shortcut" = "wine.desktop";
          "application/x-bat" = "wine.desktop";
          "application/x-mswinurl" = "wine.desktop";
          "application/vhd.microsoft.portable-executable" = "wine.desktop";
          "video/mp4" = "vlc.desktop";
          "video/x-matroska" = "vlc.desktop";
          "application/x-extension-htm" = "firefox.desktop";
          "application/x-extension-html" = "firefox.desktop";
          "application/x-extension-shtml" = "firefox.desktop";
          "application/x-extension-xht" = "firefox.desktop";
          "application/x-extension-xhtml" = "firefox.desktop";
          "text/html" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";
          "x-scheme-handler/chrome" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "model/stl" = "com.ultimaker.cura.desktop";
          "model/3mf" = "com.ultimaker.cura.desktop";
          "text/x.gcode" = "com.ultimaker.cura.desktop";
          "x-scheme-handler/ror2mm" = "r2modman.desktop";
          "image/svg+xml" = "code.desktop";
          "application/json" = "code.desktop";
          "application/xml" = "code.desktop";
          "application/yaml" = "code.desktop";
          "application/toml" = "code.desktop";
          "application/x-shellscript" = "code.desktop";
          "text/x-python" = "code.desktop";
          "text/rust" = "code.desktop";
          "text/javascript" = "code.desktop";
          "text/css" = "code.desktop";
          "text/x-cmake" = "code.desktop";
          "text/x-c++src" = "code.desktop";
          "text/x-c++hdr" = "code.desktop";
          "text/x-systemd-unit" = "code.desktop";
          "text/markdown" = "code.desktop";
          "text/plain" = "code.desktop";
          "x-scheme-handler/bitwarden" = "Bitwarden.desktop";
          "x-scheme-handler/beatsaver" = "BeatSaberModManager-url-beatsaver.desktop";
          "x-scheme-handler/bsplaylist" = "BeatSaberModManager-url-bsplaylist.desktop";
          "x-scheme-handler/modelsaber" = "BeatSaberModManager-url-modelsaber.desktop";
          "application/x-modrinth-modpack+zip" = "org.prismlauncher.PrismLauncher.desktop";
          "x-scheme-handler/curseforge" = "org.prismlauncher.PrismLauncher.desktop";
        };
      };

      catppuccin.enable = true;
      catppuccin.flavor = "mocha";
      catppuccin.accent = "pink";

      gtk = {
        enable = true;
        gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };
        gtk4.extraConfig = { gtk-application-prefer-dark-theme = true; };
        theme = {
          name = "catppuccin-mocha-pink-standard";
          package = (pkgs.catppuccin-gtk.override {
            variant = "mocha";
            accents = [ "pink" ];
          });
        };
      };

      programs = {
        kitty = {
          enable = true;
          shellIntegration.enableBashIntegration = true;
          font = {
            name = "Fira Code";
            package = pkgs.nerd-fonts.fira-code;
          };
        };
        hyfetch = {
          enable = true;
          settings = {
            preset = "transgender";
            mode = "rgb";
            light_dark = "dark";
            lightness = 0.65;
            color_align = {
              mode = "horizontal";
              custom_colors = [ ];
              fore_back = null;
            };
            backend = "fastfetch";
            distro = null;
            pride_month_shown = [ ];
          };
        };
        starship = {
          enable = true;
          enableBashIntegration = true;
          settings = {
            directory = {
              truncation_length = 12;
              truncate_to_repo = false;
              truncation_symbol = "…/";
            };
          };
        };
        zoxide = {
          enable = true;
          enableBashIntegration = true;
          options = [
            "--cmd cd"
          ];
        };
        bash = {
          enable = true;
          bashrcExtra = ''
            if [ -n "$PS1" ]; then
                # Run hyfetch if the shell is interactive
                hyfetch
            fi
          '';
        };
        ssh = {
          enable = true;
          matchBlocks = {
            hiltrud = {
              hostname = "192.168.178.167";
              user = "mks";
            };

            discord-bots = {
              hostname = "192.168.178.10";
            };

            discord-bots-root = {
              hostname = "192.168.178.10";
              user = "root";
            };

            mongo-db = {
              hostname = "192.168.178.9";
            };

            smart-home = {
              hostname = "192.168.178.6";
            };

            tor-node = {
              hostname = "192.168.178.18";
            };

            xen-orchestra = {
              hostname = "192.168.178.5";
            };

            gutruhn = {
              hostname = "192.168.178.3";
            };

            hedwig = {
              hostname = "192.168.178.4";
              user = "root";
            };

            errol = {
              hostname = "192.168.178.11";
              user = "root";
            };

            barbara = {
              hostname = "192.168.178.100";
            };

            rouge = {
              hostname = "192.168.178.178";
            };
          };
          extraConfig = ''
            StrictHostKeyChecking accept-new
            User aki
          '';
        };
        tealdeer = {
          enable = true;
          settings.updates = {
            auto_update = true;
            auto_update_interval_hours = 24;
          };
        };
        bat.enable = true;
        btop.enable = true;
        spicetify =
          let
            spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
          in
          {
            enable = true;
            enabledExtensions = with spicePkgs.extensions; [
              shuffle
              groupSession
              listPlaylistsWithSong
              playlistIntersection
              skipStats
              phraseToPlaylist
              showQueueDuration
              copyToClipboard
              history
              betterGenres
              savePlaylists
              autoSkip
              playNext
              volumePercentage
              playingSource
              oneko
              starRatings
            ];
            enabledCustomApps = with spicePkgs.apps; [
              newReleases
              marketplace
              localFiles
            ];
            theme = spicePkgs.themes.catppuccin;
            colorScheme = "mocha";
          };
      };
      xdg.configFile."autostart/vesktop.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Vesktop
        Comment=Vesktop autostart script
        Exec=vesktop
        StartupNotify=false
        Terminal=false
      '';
      xdg.configFile."autostart/openrgb.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=OpenRGB
        Comment=OpenRGB autostart script
        Exec=openrgb --startminimized --profile Pink
        StartupNotify=false
        Terminal=false
      '';
      xdg.desktopEntries."Update VMs" = {
        type = "Application";
        name = "Update VMs";
        exec = "bash /home/aki/update_vms.sh";
        icon = "system-software-update";
        terminal = true;
      };
      home.file."update_vms.sh" = {
        executable = true;
        text = ''
          #!/bin/bash

          HOSTS_TO_UPDATE="discord-bots
          mongo-db
          xen-orchestra"

          # Get Password
          read -sp "Password please: " PASSWORD
          echo ""

          # Getting sudo perms
          echo $PASSWORD | sudo -S echo "Thanks, checking password" >/dev/null 2>&1 # -S just yeets the password into sudo so i dont have to type it out again, and also dont need to remember to use sudo on the script
          echo ""

          sudo -n true 2>/dev/null
          if ! [ $? -eq 0 ]; then
              echo "Password Wrong"
              read -p "Press enter to continue"
              exit 0
          fi

          for host in $HOSTS_TO_UPDATE; do
              echo -e "\033[1m\033[32m$host\033[0m"

              # Run interactive shell on remote machine
              ssh -t $host "bash <<EOF
          echo $PASSWORD | sudo -S dpkg --configure -a && NEEDRESTART_MODE=a DEBIAN_FRONTEND=noninteractive bash update.sh
          EOF"
              echo -e "\033[1m\033[32mDone\033[0m"
              echo ""
          done

          echo "Updated everything, VMs are rebooting"
          read -p "Press enter to continue"
        '';
      };
    };
    users.scarlett = {
      home.stateVersion = "23.11";

      systemd.user.services."sshfs-scarlett-home" = {
        Unit = {
          Description = "SSHFS Mount for Scarletts Home";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Service = {
          ExecStart = "${pkgs.sshfs}/bin/sshfs -f -o delay_connect,reconnect,ServerAliveInterval=10,ServerAliveCountMax=2,_netdev,user,transform_symlinks,IdentityFile=/home/scarlett/.ssh/id_ed25519,allow_other,default_permissions,uid=1001,gid=100,exec Scar@toasteruwu.com:/home /home/scarlett/NAS/home";
          ExecStop = "${pkgs.fuse}/bin/fusermount -u /home/scarlett/NAS/home";
          Restart = "on-failure";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/scarlett/NAS/home";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      catppuccin.enable = true;
      catppuccin.flavor = "mocha";
      catppuccin.accent = "red";

      gtk = {
        enable = true;
        gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };
        gtk4.extraConfig = { gtk-application-prefer-dark-theme = true; };
        theme = {
          name = "catppuccin-mocha-red-standard";
          package = (pkgs.catppuccin-gtk.override {
            variant = "mocha";
            accents = [ "red" ];
          });
        };
      };

      programs = {
        kitty = {
          enable = true;
          shellIntegration.enableBashIntegration = true;
          font = {
            name = "Fira Code";
            package = pkgs.nerd-fonts.fira-code;
          };
        };
        hyfetch = {
          enable = true;
          settings = {
            preset = "akiosexual";
            mode = "rgb";
            light_dark = "dark";
            lightness = 0.65;
            color_align = {
              mode = "horizontal";
              custom_colors = [ ];
              fore_back = null;
            };
            backend = "fastfetch";
            distro = null;
            pride_month_shown = [ ];
          };
        };
        starship = {
          enable = true;
          enableBashIntegration = true;
          settings = {
            directory = {
              truncation_length = 12;
              truncate_to_repo = false;
              truncation_symbol = "…/";
            };
          };
        };
        zoxide = {
          enable = true;
          enableBashIntegration = true;
          options = [
            "--cmd cd"
          ];
        };
        bash = {
          enable = true;
          bashrcExtra = ''
            if [ -n "$PS1" ]; then
                # Run hyfetch if the shell is interactive
                hyfetch
            fi
          '';
        };
        tealdeer = {
          enable = true;
          settings.updates = {
            auto_update = true;
            auto_update_interval_hours = 24;
          };
        };
        bat.enable = true;
        btop.enable = true;
      };
      xdg.configFile."autostart/vesktop.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Vesktop
        Comment=Vesktop autostart script
        Exec=vesktop
        StartupNotify=false
        Terminal=false
      '';
      xdg.configFile."autostart/openrgb.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=OpenRGB
        Comment=OpenRGB autostart script
        Exec=openrgb --startminimized --profile Red
        StartupNotify=false
        Terminal=false
      '';
      xdg.configFile."autostart/brave-browser.desktop".text = ''
        [Desktop Entry]
        Version=1.0
        Name=Brave Web Browser
        Exec=brave %U
        StartupNotify=true
        Terminal=false
        Icon=brave-browser
        Type=Application
        Categories=Network;WebBrowser;
      '';
      xdg.configFile."autostart/steam.desktop".text = ''
        [Desktop Entry]
        Name=Steam
        Exec=steam %U
        Icon=steam
        Terminal=false
        Type=Application
        PrefersNonDefaultGPU=true
        X-KDE-RunOnDiscreteGpu=true
      '';
      xdg.configFile."autostart/set-ratbagd-profile.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Set Ratbagd Profile
        Exec=ratbagctl hollering-marmot profile active set 2
        StartupNotify=false
        Terminal=false
      '';
    };
  };
}
