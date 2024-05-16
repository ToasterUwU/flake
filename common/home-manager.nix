{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [
      inputs.catppuccin.homeManagerModules.catppuccin
    ];

    users.aki = {
      home.stateVersion = "23.11";
      gtk = {
        enable = true;
        catppuccin.enable = true;
      };
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
          catppuccin.enable = true;
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
        bat = {
          enable = true;
          catppuccin.enable = true;
        };
        bottom = {
          enable = true;
          catppuccin.enable = true;
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
      programs.hyfetch = {
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
