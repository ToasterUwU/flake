{ ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1"; # Allow unfree software when using nix-shell
  hardware.enableAllFirmware = true;
}
