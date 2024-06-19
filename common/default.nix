let
  # List all files in the specified subdirectory
  allFiles = builtins.readDir ./.;

  # Filter and import all Nix files from the subdirectory, excluding default.nix
  imports = map (file: import (./. + "/${file}"))
    (builtins.filter (file: builtins.match ".*\\.nix" file != null && file != "default.nix") (builtins.attrNames allFiles));
in
{
  inherit imports;
}
