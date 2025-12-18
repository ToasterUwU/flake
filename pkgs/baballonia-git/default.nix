{
  config,
  pkgs,
  lib,
  enableCuda ? config.cudaSupport,
  ...
}:
let
  babbleTrainer = pkgs.callPackage ./babble-trainer.nix { inherit enableCuda; };

  # TODO: figure out how to build & run Godot OpenXR projects.
  calibZip = pkgs.fetchurl {
    url = "https://github.com/Project-Babble/BabbleCalibration/releases/download/1.0.5/Linux.zip";
    hash = "sha256-L5ssy6nLvwzpWeSMvVMZoWnmCY9uK/5LVckJmf3hGdo=";
    executable = true;
  };

  opencvsharp = pkgs.stdenv.mkDerivation rec {
    # TODO: figure out how this works on ROCm...

    pname = "opencvsharp";
    version = "4.11.0.20250507";

    src = pkgs.fetchFromGitHub {
      owner = "shimat";
      repo = "opencvsharp";
      tag = version;
      hash = "sha256-CkG4Kx/AkZqyhtclMfS51a9a9R+hsqBRlM4fry32YJ0=";
    };
    sourceRoot = "${src.name}/src";

    buildInputs = [ pkgs.opencv ] ++ lib.optionals enableCuda [ pkgs.cudaPackages.cudatoolkit ];

    nativeBuildInputs = [ pkgs.cmake ];

    cmakeFlags = [
      (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
    ] ++ lib.optionals enableCuda [ "-DCUDAToolkit_ROOT=${pkgs.cudaPackages.cudatoolkit}" ];
  };
in
pkgs.buildDotnetModule (finalAttrs: {
  # TODO: figure out how this works on ROCm...
  # * Probably a different onnxruntime?
  # * Opencvsharp should just work, I think...
  # * What about babble-trainer?

  version = "0.0.0";
  pname = "baballonia";

  # https://github.com/Naraenda/Baballonia/tree/next-v3
  # - bsb2e camera through libuvc
  # - vft fix
  # - packaging fix for nix
  # - no micros*ft onnxruntime
  src = pkgs.fetchFromGitHub {
    owner = "naraenda";
    repo = "Baballonia";
    rev = "a8c813e267c26f51f1d62bf0c8ba687ef92c618b";
    sha256 = "sha256-H5W+QsvccLOKzqqDIp7Xio5DZlUbRkT5HB4I66NBDhE=";
    fetchSubmodules = true;
  };
  projectFile = "src/Baballonia.Desktop/Baballonia.Desktop.csproj";
  nugetDeps = ./deps.json;
  dotnetSdk = pkgs.dotnetCorePackages.dotnet_8.sdk;
  dotnetRuntime = pkgs.dotnetCorePackages.dotnet_8.runtime;

  buildInputs = with pkgs; [
    cmake
    copyDesktopItems
    fontconfig
    libGL
    libjpeg
    libusb1
    libuvc
    opencv
    opencvsharp
    udev
    unzip
    xorg.libICE
    xorg.libSM
    xorg.libX11
  ];

  runtimeDeps =
    with pkgs;
    [
      libusb1
      libuvc
      libxcb
      libxcursor
      libxext
      libxi
      libxkbcommon
      opencvsharp
      udev
      libGL
    ]
    ++ lib.optionals (!enableCuda) [ onnxruntime ]
    ++ lib.optionals enableCuda [ pkgsCuda.onnxruntime ];

  postUnpack = ''
    unzip ${calibZip} -d $sourceRoot/src/Baballonia.Desktop/Calibration/Linux/Overlay
    ln -s ${babbleTrainer}/bin/babble-trainer $sourceRoot/src/Baballonia.Desktop/Calibration/Linux/Trainer/BabbleTrainer
  '';

  postFixup =
    let
      # The internal calibration tool. We need to wrap this so it launches properly.
      calibTool = "$out/lib/baballonia/Calibration/Linux/Overlay/BabbleCalibration.x86_64";
    in
    ''
      # Clear out bin folder, we'll link since some of these may need
      # to be wrapped. We'll also want to rename them for consistency's
      # sake.
      rm $out/bin/*

      # Ensure BabbleTrainer knows where to put temporary files (NEW!!!)
      wrapDotnetProgram $out/lib/baballonia/Baballonia.Desktop $out/bin/baballonia \
        --set BABBLE_TRAINER_TMP_DIR /tmp

      # Godot applications requires steam-run for whatever reason.
      # I'm too lazy to figure out what part of the FSH it needs.
      # https://nixos.wiki/wiki/Godot
      #
      # Create a backup of the original.
      mv ${calibTool} ${calibTool}-original
      # And wrap it!
      makeWrapper ${pkgs.steam-run}/bin/steam-run \
        ${calibTool} \
        --add-flags ${calibTool}-original \
        --add-flags --xr-mode \
        --add-flags on \
        --set XR_LOADER_DEBUG all

      # Actually export our binaries.
      ln -s ${calibTool} $out/bin/babble-calibration
      ln -s ${babbleTrainer}/bin/babble-trainer $out/bin/babble-trainer
    '';

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "Baballonia";
      comment = finalAttrs.meta.description;
      exec = "${finalAttrs.meta.mainProgram} %u";
      terminal = false;
      type = "Application";
      icon = "baballonia"; # TODO: fetch icon
      categories = [ "Game" ];
    })
  ];

  meta = {
    mainProgram = "baballonia";
    platforms = lib.platforms.linux;
    homepage = "https://github.com/Project-Babble/Baballonia";
    description = "Free and open source eye and face tracking for social VR";
    maintainers = with lib.maintainers; [ naraenda ];
  };
})
