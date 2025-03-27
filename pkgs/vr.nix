{ pkgs, ... }:
let
  monado-run-scripts = pkgs.stdenv.mkDerivation {
    pname = "monado-run-scripts";
    version = "1.1";

    src = ../assets/scripts/monado-run-scripts;

    desktopItems = [
      (pkgs.makeDesktopItem {
        exec = "monado-start";
        icon = "steamvr";
        name = "Start Monado";
        desktopName = "Start Monado";
        terminal = true;
      })
      (pkgs.makeDesktopItem {
        exec = "monado-stop";
        icon = "steamvr";
        name = "Stop Monado";
        desktopName = "Stop Monado";
        terminal = true;
      })
    ];

    buildInputs = [ pkgs.bash ];

    installPhase = ''
      mkdir -p $out/bin
      cp $src/start.sh $out/bin/monado-start
      chmod +x $out/bin/monado-start
      cp $src/stop.sh $out/bin/monado-stop
      chmod +x $out/bin/monado-stop
    '';

    meta = with pkgs.lib; {
      description = "Start and Stop scripts for monado and all other things i use with it.";
    };
  };
in
{
  environment.systemPackages = [
    monado-run-scripts
  ];
}