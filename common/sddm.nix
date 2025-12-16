{ ... }:
{
  services = {
    xserver.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
      };
    };
  };
}
