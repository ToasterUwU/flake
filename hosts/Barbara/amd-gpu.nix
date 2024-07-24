{ pkgs, ... }: {
  imports = [ ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  services.ollama = {
    package = pkgs.ollama-rocm;
    acceleration = "rocm";
  };
}
