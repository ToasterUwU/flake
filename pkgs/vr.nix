{ pkgs, ... }:
let
  lovr = pkgs.stdenv.mkDerivation rec {
    pname = "lovr";
    version = "v0.17.1";
    src = [
      (pkgs.fetchFromGitHub {
        name = pname;
        owner = "bjornbytes";
        repo = pname;
        fetchSubmodules = true;
        rev = "161856b5ed4e6db38653552f515d58b6b485bf9b"; # latest release is broken
        hash = "sha256-cO9cJH1/9hy0LmAuINXOERZ64nzwna9kPZlFGndsL+g=";
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
    version = "0.1.0";
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
          hash = "sha256-nW4hyEf35NlfqljKKy47NC2pr3EuCKb4HbsFh8+CGRQ=";
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
    version = "2.0";

    src = pkgs.writeShellApplication {
      name = "monado-start";

      runtimeInputs =
        with pkgs;
        [
          wlx-overlay-s
          wayvr-dashboard
          # index_camera_passthrough
        ]
        ++ [
          # lovr-playspace
        ];

      text = ''
        #! /usr/bin/env bash

        function clean_up() {
            echo "exiting"
            jobs -p | xargs kill
            systemctl --user stop monado.service
            echo "bye!"
        }
        export -f clean_up

        trap clean_up EXIT

        systemctl --user restart monado.service

        # lovr-playspace &
        wlx-overlay-s --replace &
        # index_camera_passthrough &

        trap "echo 'CTRL+C pressed. Exiting...'; clean_up; exit" SIGINT
        while true; do
            sleep 1
        done
      '';
    };

    buildInputs = with pkgs; [ bash ];

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
  environment.systemPackages = [ monado-start ];
}
