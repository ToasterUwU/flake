# steam-launch.nix (Home Manager version)
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.steam-launch-options;

  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      vdf
    ]
  );

  mergerScript = pkgs.writeScript "steam-launch-options-merger.py" ''
    #!${pythonEnv}/bin/python3
    ${builtins.readFile ./main.py}
  '';
in
{
  options.programs.steam-launch-options = {
    enable = lib.mkEnableOption "Steam launch options management";

    userId = lib.mkOption {
      type = lib.types.str;
      example = "12345678";
      description = ''
        Your Steam user ID found in ~/.steam/steam/userdata/
      '';
    };

    launchOptions = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        "730" = "-novid -console";
        "440" = "-windowed -noborder";
      };
      description = ''
        Attribute set where keys are Steam AppIDs and values are launch options
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.python3.withPackages (ps: [ ps.vdf ]))
    ];

    home.activation.steamLaunchOptions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pythonEnv}/bin/python3 ${mergerScript} \
        --user-id "${cfg.userId}" \
        --launch-options ${lib.escapeShellArg (builtins.toJSON cfg.launchOptions)}
    '';
  };
}
