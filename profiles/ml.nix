{ config, pkgs, ... }:
{
  imports = [ ./dev.nix ];  # ml includes everything in dev

  home.packages = with pkgs; [
    python3
    python3Packages.pip
    python3Packages.virtualenv
    jupyter
    ruff          # fast python linter
    uv            # fast pip replacement
  ];
}
