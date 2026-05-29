{ config, pkgs, ... }:
{
  imports = [ ../base.nix ];

  home.packages = with pkgs; [
    brave
    nodejs
    python3
    gcc
    gnumake
    docker-compose
    postman
    git-lfs
    gh          # github cli
  ];

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
      ];
      userSettings = {
        "editor.fontSize" = 14;
        "editor.fontFamily" = "NotoSansMono-Regular";
        "workbench.colorTheme" = "One Dark Pro";
        "editor.renderWhitespace" = "none";
        "editor.minimap.enabled" = false;
        "editor.smoothScrolling" = false;
        "workbench.enableExperiments" = false;
        "extensions.autoUpdate" = false;
        "telemetry.telemetryLevel" = "off";
        "files.watcherExclude" = {
          "**/.git/objects/**" = true;
          "**/node_modules/**" = true;
          "**/__pycache__/**" = true;
          "**/.venv/**" = true;
        };
      };
    };
  };
}
