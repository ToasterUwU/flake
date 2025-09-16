{ pkgs, ... }:
let
  lovr = pkgs.stdenv.mkDerivation rec {
    pname = "lovr";
    version = "0.18.0";
    src = [
      (pkgs.fetchFromGitHub {
        name = pname;
        owner = "bjornbytes";
        repo = pname;
        fetchSubmodules = true;
        rev = "v${version}";
        hash = "sha256-SyKJv9FmJyLGc3CT0JBNewvjtsmXKxiqaptysWiY4co=";
      })
      (pkgs.fetchFromGitHub {
        # This gets pulled in via cmake and not as a submodule, so we need to get it and tell cmake that we already have it
        name = "JoltPhysics";
        owner = "jrouwe";
        repo = "JoltPhysics";
        fetchSubmodules = true;
        rev = "c10d9b2a8ee134fb5e72de1a0f26f8c9cc8f6382";
        hash = "sha256-owI9uM/hjicuUWXYeZOhfYby5ygWm3JOO/qifRGiOdM=";
      })
    ];
    sourceRoot = pname;

    buildInputs = with pkgs; [
      wayland
      luajit
      glfw
      glslang
      openxr-loader
      vulkan-loader
      ode
      libxcb
      xorg.libX11
      xorg.libXrandr
      xorg.libXinerama
      xorg.libXcursor
      xorg.xinput
      xorg.libXi
      python3
      curl
      git
    ];
    nativeBuildInputs = with pkgs; [
      cmake
      pkg-config
      wayland
    ];
    cmakeFlags = with pkgs; [
      (lib.cmakeOptionType "path" "FETCHCONTENT_SOURCE_DIR_JOLTPHYSICS" "${builtins.elemAt src 1}")
      (lib.cmakeBool "GLFW_BUILD_WAYLAND" true)
      (lib.cmakeBool "LOVR_SYSTEM_GLFW" true)
      (lib.cmakeBool "LOVR_SYSTEM_LUA" true)
      (lib.cmakeBool "LOVR_SYSTEM_OPENXR" true)
      (lib.cmakeBool "LOVR_BUILD_BUNDLE" true)
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/lib
      cp -r bin/lovr $out/bin/
      cp -r bin/*.so $out/lib/
      runHook postInstall
    '';
  };

  lovr-playspace = pkgs.symlinkJoin rec {
    pname = "lovr-playspace";
    version = "0.2.1";
    paths = [
      lovr
      (pkgs.stdenv.mkDerivation {
        pname = "${pname}-unwrapped";
        version = "${version}";
        src = pkgs.fetchFromGitHub {
          name = pname;
          owner = "SpookySkeletons";
          repo = pname;
          tag = "${version}";
          fetchSubmodules = true;
          hash = "sha256-3OfXFMjfSyr7e37N0Zw96/xFoCgriatxE/PFyfPJg90=";
        };

        dontUseCmakeConfigure = true;

        installPhase = ''
          runHook preInstall
          mkdir -p $out/lovr-playspace $out/lovr-playspace/json
          cp -r ./*.lua $out/lovr-playspace/
          cp -r ./json/*.lua $out/lovr-playspace/json/
          runHook postInstall
        '';
      })
      (pkgs.writeTextFile {
        name = "lovr-playspace-script";
        executable = true;
        destination = "/bin/lovr-playspace";
        text = ''
          #!${pkgs.bash}/bin/bash
          ${lovr}/bin/lovr ${builtins.elemAt paths 1}/lovr-playspace
        '';
      })
    ];
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
          # index_camera_passthrough
          lighthouse-steamvr
          kdePackages.kde-cli-tools
        ]
        ++ [
          lovr-playspace
        ];

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
            lovr-playspace &
            wlx-overlay-s --replace &
            # index_camera_passthrough &
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
        off
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
    lovr-playspace
    pkgs.lighthouse-steamvr
  ];
}
