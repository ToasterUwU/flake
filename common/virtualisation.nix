{ pkgs, ... }:
{
  virtualisation.containers.enable = true;
  virtualisation = {
    docker = {
      enable = true;
    };
  };

  virtualisation.waydroid.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    lazydocker # status of containers in the terminal
    docker-compose # start group of containers

    gnome-boxes

    virtiofsd
  ];
}
