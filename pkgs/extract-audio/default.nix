{
  stdenv,
  ffmpeg-full,
  python3,
}:
stdenv.mkDerivation {
  pname = "extract-audio";
  version = "1.0";

  src = ../../assets/scripts/extract-audio;

  buildInputs = [
    ffmpeg-full
    python3
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/main.py $out/bin/extract-audio
    chmod +x $out/bin/extract-audio
  '';

  meta = {
    description = "Extract and trim audio from MKV video files.";
  };
}
