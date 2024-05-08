{ config, ... }:
let
  isWaltraud = config.networking.hostName == "Waltraud";
in
{
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "aki" ];

  virtualisation.virtualbox.host.enable = !isWaltraud;
  virtualisation.virtualbox.host.enableExtensionPack = !isWaltraud;
  users.extraGroups.vboxusers.members = if isWaltraud then [] else [ "aki" ];

  virtualisation.waydroid.enable = true;
}
