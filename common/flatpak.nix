{ inputs, ... }: {
  imports = [ ];

  services.flatpak.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [
      inputs.flatpaks.homeManagerModules.declarative-flatpak
    ];

    users.aki = {
      services.flatpak = {
        remotes = {
          "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        };
        packages = [
          flathub:app/camp.nook.nookdesktop/x86_64/stable
          flathub:app/com.ultimaker.cura/x86_64/stable
          flathub:app/dev.geopjr.Collision/x86_64/stable
          flathub:app/com.vysp3r.ProtonPlus/x86_64/stable
        ];
      };
    };

    users.scarlett = {
      services.flatpak = {
        remotes = {
          "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        };
        packages = [
          flathub:app/com.vysp3r.ProtonPlus/x86_64/stable
        ];
      };
    };
  };
}
