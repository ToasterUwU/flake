{ pkgs, ... }:
let
  monado-run-scripts = pkgs.stdenv.mkDerivation {
    pname = "extract-audio";
    version = "1.0";

    src = ../assets/scripts/monado-run-scripts;

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