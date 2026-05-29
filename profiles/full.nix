{ config, pkgs, ... }:
{
  imports = [ ./ml.nix ];  # full includes everything

  home.packages = with pkgs; [
    brave
    obs-studio
    vlc
    gimp
  ];
}
