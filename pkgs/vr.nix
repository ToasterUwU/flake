{ pkgs, ... }:
let
  monado-start-desktop = pkgs.makeDesktopItem {
    exec = "monado-start";
    icon = "steamvr";
    name = "Start Monado";
    desktopName = "Start Monado";
    terminal = true;
  };

  monado-stop-desktop = pkgs.makeDesktopItem {
    exec = "monado-stop";
    icon = "steamvr";
    name = "Stop Monado";
    desktopName = "Stop Monado";
    terminal = true;
  };

  monado-run-scripts = pkgs.stdenv.mkDerivation {
    pname = "monado-run-scripts";
    version = "1.1";

    src = ../assets/scripts/monado-run-scripts;

    buildInputs = [ pkgs.bash ];

    installPhase = ''
      mkdir -p $out/bin $out/share/applications
      cp $src/start.sh $out/bin/monado-start
      chmod +x $out/bin/monado-start
      cp $src/stop.sh $out/bin/monado-stop
      chmod +x $out/bin/monado-stop
      cp -r ${monado-start-desktop}/* $out/
      cp -r ${monado-stop-desktop}/* $out/
    '';

    meta = with pkgs.lib; {
      description = "Start and Stop scripts for monado and all other things i use with it.";
    };
  };
in
{
  environment.systemPackages = [ monado-run-scripts ];
}
