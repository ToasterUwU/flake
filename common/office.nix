{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libreoffice-qt-fresh
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
  ];
}
