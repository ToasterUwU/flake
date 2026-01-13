{
  pkgs,
  lib,
  enableCuda,
  ...
}:
let
  pyPkgs = pkgs.python3Packages;

  onnxscript = pyPkgs.buildPythonPackage rec {
    pname = "onnxscript";
    version = "0.5.7";
    format = "wheel";
    src = pkgs.fetchPypi {
      inherit pname version format;
      python = "py3";
      dist = "py3";
      abi = "none";
      platform = "any";
      hash = "sha256-+UpmBZxW0TtEkI6bf9na5LT6pmgceE8/1MKc+oY+RU4=";
    };
  };

  onnx-ir = pyPkgs.buildPythonPackage rec {
    pname = "onnx-ir";
    version = "0.1.14";
    format = "wheel";
    src = pkgs.fetchPypi {
      inherit version format;
      pname = "onnx_ir";
      python = "py3";
      dist = "py3";
      abi = "none";
      platform = "any";
      hash = "sha256-ibIS+nhAmBxdtdxHgZDxtzaVNil8PG6uaPscIjfdJVQ=";
    };
  };

  babble-trainer-src = pkgs.fetchFromGitHub {
    owner = "Project-Babble";
    repo = "BabbleTrainer";
    rev = "1.3.8-linux-paths";
    hash = "sha256-ECK4ApmPl2X41w8yshjUTdZleR4X3Tmh47r0CO28f0Y=";
  };

  opencv2 = pkgs.opencv.override (old: {
    enableGtk2 = true;
  });

  babble-data = pyPkgs.buildPythonPackage {
    pname = "babble_data";
    version = "1.3.8-linux-paths";
    src = "${babble-trainer-src}/babble_data";
    pyproject = true;
    build-system = [ pyPkgs.setuptools ];
    buildInputs = [
      pyPkgs.numpy
      opencv2
    ] ++ lib.optionals enableCuda [ pkgs.cudaPackages.cudatoolkit ];
    nativeBuildInputs = [ pkgs.pkg-config ];
  };

  # Python depedencies we should have. For some reason,
  # nixpkgs do not include all ONNX support packages so
  # we have to fetch them ourselves.
  pythonEnv = pkgs.python3.withPackages (ps: [
    ps.torch
    # Direct depedencies:
    ps.numpy
    ps.onnx
    ps.opencv-python
    ps.pillow
    ps.tqdm
    # Indrect depedency for ONNX exporting:
    ps.torchvision
    # Out-of-tree depedencies for ONNX exporting:
    onnxscript
    onnx-ir
    babble-data
  ]);
in
pyPkgs.buildPythonPackage {
  pname = "babble-trainer";
  version = "1.3.8";
  pyproject = false;
  doCheck = false;

  src = babble-trainer-src;

  # The original project uses pyinstaller with a .spec-file.
  # We don't really need that because we can ensure that the
  # right depedencies are installed ourselves. We instead add
  # a shebang pointing to our own python environment!
  #
  # TODO If BabbleTrainer every becomes more complex, we may need to
  # to redirect from /bin to /lib to not pollute /bin!
  buildPhase = ''
    mkdir -p $out/bin
    echo "#!${pythonEnv}/bin/python3" > $out/bin/babble-trainer
    cat main.py >> $out/bin/babble-trainer
    chmod +x $out/bin/babble-trainer

    cp trainer_distsampler.py $out/bin/
    cp models.py $out/bin/
    cp data.py $out/bin/
  '';

  installPhase = ''
    # Skipped!
  '';

  patches = [
    ./tmp-dir-fixes.patch
  ];

  meta = {
    description = "BabbleTrainer";
    platforms = pkgs.lib.platforms.linux;
    maintainers = with lib.maintainers; [ toasteruwu ];
  };
}
