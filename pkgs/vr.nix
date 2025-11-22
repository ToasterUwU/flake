{ pkgs, ... }:
let
  go-bsb-cams = pkgs.buildGoModule {
    pname = "go-bsb-cams";
    version = "8a2728ccf20d1a1a2a51c9ad9ebf364aa18e78cb";
    src = pkgs.fetchFromGitHub {
      owner = "Red-M";
      repo = "go-bsb-cams";
      rev = "8a2728ccf20d1a1a2a51c9ad9ebf364aa18e78cb";
      fetchSubmodules = false;
      hash = "sha256-iExK4l0eHX2Lm27vs84NDuHEoA50t7NB8aRE9kyidtk=";
    };

    buildInputs = [ pkgs.libusb1 ];
    nativeBuildInputs = [ pkgs.pkg-config ];

    ld-flags = [
      "-s"
      "-w"
    ];

    vendorHash = "sha256-qFe8doA3L/77XsmIhZsqsjlCFxmlsZfvqwTPtBHgOHA=";

    meta = {
      mainProgram = "go-bsb-cams";
      platforms = pkgs.lib.platforms.linux;
      homepage = "https://github.com/LilliaElaine/go-bsb-cams";
      description = "Simple program to take and output the Bigscreen Beyond 2e cameras to a webserver";
    };
  };

  monado-start-desktop = pkgs.makeDesktopItem {
    exec = "monado-start";
    icon = "steamvr";
    name = "Start Monado";
    desktopName = "Start Monado";
    terminal = true;
  };

  monado-start = pkgs.stdenv.mkDerivation {
    pname = "monado-start";
    version = "3.1.0";

    src = pkgs.writeShellApplication {
      name = "monado-start";

      runtimeInputs =
        with pkgs;
        [
          wlx-overlay-s
          wayvr-dashboard
          lighthouse-steamvr
          kdePackages.kde-cli-tools
          lovr-playspace
        ]
        ++ [ go-bsb-cams ];

      checkPhase = ''
        echo "I dont care" # Fix shellcheck being upset about no direct call of "off"
      '';

      text = ''
        GROUP_PID_FILE="/tmp/monado-group-pid-$$"

        function off() {
          echo "Stopping Monado and other stuff..."

          if [ -f "$GROUP_PID_FILE" ]; then
            PGID=$(cat "$GROUP_PID_FILE")
            echo "Killing process group $PGID..."
            kill -- -"$PGID" 2>/dev/null
            rm -f "$GROUP_PID_FILE"
          fi

          systemctl --user --no-block stop monado.service
          lighthouse -vv --state off &
          wait

          exit 0
        }

        function on() {
          echo "Starting Monado and other stuff..."

          lighthouse -vv --state on &
          systemctl --user restart monado.service

          setsid sh -c '
            go-bsb-cams --port 8000 --verbose &
            lovr-playspace &
            wlx-overlay-s --replace &
            kde-inhibit --power --screenSaver sleep infinity &
            steam steam://rungameid/12777107318529589248 & # Baballonia on Steam as non-steam game
            wait
          ' &
          PGID=$!
          echo "$PGID" > "$GROUP_PID_FILE"
        }

        trap off EXIT INT TERM
        echo "Press ENTER to turn everything OFF."

        on
        read -r
        exit
      '';
    };

    installPhase = ''
      mkdir -p $out/bin
      cp $src/bin/monado-start $out/bin/
      chmod +x $out/bin/monado-start

      cp -r ${monado-start-desktop}/* $out/
    '';

    meta = {
      description = "Start script for monado and all other things i use with it.";
    };
  };
in
{
  environment.systemPackages = [
    monado-start
    go-bsb-cams
  ];
}
