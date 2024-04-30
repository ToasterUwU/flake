{ ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Barbara";
  networking.interfaces.enp16s0.wakeOnLan.enable = true;
}
