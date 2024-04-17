{ ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Barbara"; # Define your hostname.
  networking.interfaces.enp34s0.wakeOnLan.enable = true;
}
