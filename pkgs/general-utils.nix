{ pkgs, ... }:
let
  extractAudio = pkgs.stdenv.mkDerivation {
    pname = "extract-audio";
    version = "1.0";

    src = ../assets/scripts/extract-audio;

    buildInputs = [
      pkgs.ffmpeg-full
      pkgs.python3
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp $src/main.py $out/bin/extract-audio
      chmod +x $out/bin/extract-audio
    '';

    meta = with pkgs.lib; {
      description = "Extract and trim audio from MKV video files.";
    };
  };
in
{
  environment.systemPackages = [ extractAudio ];
}
