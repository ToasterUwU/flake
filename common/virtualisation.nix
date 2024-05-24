{ config, ... }:
let
  isWaltraud = config.networking.hostName == "Waltraud";
in
{
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "aki" ];

  virtualisation.virtualbox.host.enable = false; # !isWaltraud;
  virtualisation.virtualbox.host.enableExtensionPack = false; # !isWaltraud;
  users.extraGroups.vboxusers.members = if isWaltraud then [ ] else [ "aki" ];

  virtualisation.waydroid.enable = true;
}
