{ ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Rouge";
  networking.interfaces.enp34s0.wakeOnLan.enable = true;

  networking.firewall.enable = false;
}
