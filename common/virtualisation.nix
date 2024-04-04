{ inputs, pkgs, nixpkgs, ... }: {
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "aki" ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.virtualbox.guest.enable = true;
  users.extraGroups.vboxusers.members = [ "aki" ];

  virtualisation.waydroid.enable = true;
}
