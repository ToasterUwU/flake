{
  makeDesktopItem,
  stdenv,
  writeShellApplication,
  lib,
  wayvr,
  lighthouse-steamvr,
  kdePackages,
  lovr-playspace,
  baballonia,
  ...
}:
let
  monado-start-desktop = makeDesktopItem {
    exec = "monado-start";
    icon = "steamvr";
    name = "Start Monado";
    desktopName = "Start Monado";
    terminal = true;
  };
in
stdenv.mkDerivation {
  pname = "monado-start";
  version = "3.2.0";

  src = writeShellApplication {
    name = "monado-start";

    runtimeInputs = [
      wayvr
      lighthouse-steamvr
      kdePackages.kde-cli-tools
      lovr-playspace
      baballonia
    ];

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
        ${lib.getExe lighthouse-steamvr} -vv --state off &
        wait

        exit 0
      }

      function on() {
        echo "Starting Monado and other stuff..."

        ${lib.getExe lighthouse-steamvr} -vv --state on &
        systemctl --user restart monado.service

        setsid sh -c '
          ${lib.getExe lovr-playspace} &
          ${lib.getExe wayvr} --replace &
          ${lib.getExe baballonia} &
          kde-inhibit --power --screenSaver sleep infinity &
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
}
