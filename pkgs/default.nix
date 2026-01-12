{ pkgs, ... }:
{
  extract-audio = pkgs.callPackage ./extract-audio { };
  monado-start = pkgs.callPackage ./monado-start { };
  baballonia = pkgs.callPackage ./baballonia-git { };
}
