{ ... }: {
  imports = [ ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  nixpkgs.config.rocmSupport = true;
}
