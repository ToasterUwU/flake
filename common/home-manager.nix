{ inputs, pkgs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  systemd.services.delete-home-manager-blocking-files = {
    description = "Delete .gtkrc-2.0.backup in every user's home directory";
    script = ''
      while true; do
        for dir in /home/*; do
          if [ -d "$dir" ]; then
            FILE_PATH="$dir/.gtkrc-2.0.backup"
            if [ -e "$FILE_PATH" ]; then
              rm -f "$FILE_PATH"
              echo "File $FILE_PATH has been deleted."
            fi
          fi
        done
        sleep 1
      done
    '';
    path = [ pkgs.bash ];
    wantedBy = [ "multi-user.target" ];
  };

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [
      inputs.catppuccin.homeManagerModules.catppuccin
    ];

    users.aki = {
      home.stateVersion = "23.11";

      catppuccin.enable = true;
      catppuccin.flavor = "mocha";
      catppuccin.accent = "pink";

      gtk.enable = true;

      programs = {
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
        tealdeer = {
          enable = true;
          settings.updates = {
            auto_update = true;
            auto_update_interval_hours = 24;
          };
        };
        bat.enable = true;
        bottom.enable = true;
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
      xdg.configFile."autostart/vdhcoapp-install.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Vdhcoapp Install
        Exec=vdhcoapp install
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
      home.file.".ssh/config" = {
        target = ".ssh/config_source";
        onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 400 ~/.ssh/config'';
        text = ''
          Host hiltrud
              Hostname 192.168.178.167
              User mks

          Host discord-bots
              HostName 192.168.178.10

          Host discord-bots-root
              HostName 192.168.178.10
              User root

          Host internet-vm
              HostName 192.168.178.2

          Host mongo-db
              HostName 192.168.178.9

          Host smart-home
              HostName 192.168.178.6

          Host airvpn-tunnel-vm
              HostName 192.168.178.14

          Host surreal-db
              HostName 192.168.178.69

          Host video-station
              HostName 192.168.178.30

          Host tor-node
              HostName 192.168.178.18

          Host xen-orchestra
              HostName 192.168.178.5

          Host minecraft-vm
              HostName 192.168.178.42

          Host ollama
              HostName 192.168.178.24

          Host gutruhn
              HostName 192.168.178.3

          Host hedwig
              HostName 192.168.178.4
              User root

          Host barbara
              HostName 192.168.178.100

          Host *
              StrictHostKeyChecking accept-new
              User aki
        '';
      };
      home.file."update_vms.sh" = {
        executable = true;
        text = ''
          #!/bin/bash

          HOSTS_TO_UPDATE="airvpn-tunnel-vm
          discord-bots
          mongo-db
          ollama
          smart-home
          video-station
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
              sshpass -p $PASSWORD ssh $host "echo $PASSWORD | DEBIAN_FRONTEND=noninteractive sudo -S bash update.sh"
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

      catppuccin.enable = true;
      catppuccin.flavor = "mocha";
      catppuccin.accent = "red";

      gtk.enable = true;

      programs = {
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
            hyfetch
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
        bottom.enable = true;
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
      xdg.configFile."autostart/vdhcoapp-install.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Vdhcoapp Install
        Exec=vdhcoapp install
        StartupNotify=false
        Terminal=false
      '';
    };
  };
}
