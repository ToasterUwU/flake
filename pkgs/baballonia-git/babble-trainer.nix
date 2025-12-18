{
  config,
  pkgs,
  lib,
  enableCuda ? config.cudaSupport,
  ...
}:
let
  pyPkgs = pkgs.python3Packages;

  onnxscript = pyPkgs.buildPythonPackage rec {
    pname = "onnxscript";
    version = "0.5.6";
    format = "wheel";
    src = pkgs.fetchPypi {
      inherit pname version format;
      python = "py3";
      dist = "py3";
      abi = "none";
      platform = "any";
      hash = "sha256-sMM1X+o+7KuMopHai3ev3cqs062l7lkpQ5CgSeoSOTg=";
    };
  };

  onnx-ir = pyPkgs.buildPythonPackage rec {
    pname = "onnx-ir";
    version = "0.1.12";
    format = "wheel";
    src = pkgs.fetchPypi {
      inherit version format;
      pname = "onnx_ir";
      python = "py3";
      dist = "py3";
      abi = "none";
      platform = "any";
      hash = "sha256-F/hvr4pTuXlDC94bxgIsehYrDRU0VQ3bF6HTfrmT52U=";
    };
  };

  # Python depedencies we should have. For some reason,
  # nixpkgs do not include all ONNX support packages so
  # we have to fetch them ourselves.
  pythonEnv = pkgs.python3.withPackages (ps: [
    (if enableCuda then ps.torchWithCuda else ps.torch)
    # Direct depedencies:
    ps.numpy
    ps.onnx
    ps.opencv-python
    ps.pillow
    # Indrect depedency for ONNX exporting:
    ps.torchvision
    # Out-of-tree depedencies for ONNX exporting:
    onnxscript
    onnx-ir
  ]);
in
pyPkgs.buildPythonPackage {
  # TODO: figure out how this works on ROCm...
  # * It should just be the same package because of HIP.
  # * Need to verify and test.

  pname = "babble-trainer";
  version = "0.0.0";
  pyproject = false;
  doCheck = false;

  # https://github.com/Naraenda/BabbleTrainer/commits/various-fixes/
  #
  # TODO: move this over to main once this gets merged:
  #   https://github.com/Project-Babble/BabbleTrainer/pull/4
  src = pkgs.fetchFromGitHub {
    owner = "Naraenda";
    repo = "BabbleTrainer";
    rev = "5c0da3da660e4f70f9d6c8ea00a02c57b4e3d170";
    hash = "sha256-o2WFfhQHxsdK3xbTQYN2z+jOQqUJeJ1YTVnfOqUA5Hk=";
  };

  # The original project uses pyinstaller with a .spec-file.
  # We don't really need that because we can ensure that the
  # right depedencies are installed ourselves. We instead add
  # a shebang pointing to our own python environment!
  #
  # If BabbleTrainer every becomes more complex, we may need to
  # to redirect from /bin to /lib to not pollute /bin!
  buildPhase = ''
    mkdir -p $out/bin
    echo "#!${pythonEnv}/bin/python3" > $out/bin/babble-trainer
    cat trainermin.py >> $out/bin/babble-trainer
    chmod +x $out/bin/babble-trainer
  '';

  installPhase = ''
    # Skipped!
  '';

  meta = {
    description = "BabbleTrainer built with PyInstaller";
    platforms = pkgs.lib.platforms.linux;
    maintainers = with lib.maintainers; [
      naraenda
    ];
  };
}
