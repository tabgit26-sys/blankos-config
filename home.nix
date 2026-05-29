{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home.username = "blank";
  home.homeDirectory = "/home/blank";
  home.stateVersion = "26.05";

  # ── Packages ──────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    # Utils
    git
    btop
    ripgrep
    fd
    bat
    eza
    fzf
    unzip
    wget
    curl
    less
    jq
    fastfetch
    linuxPackages.cpupower

    # Wayland / desktop
    wofi
    wl-clipboard
    grim
    slurp
    swaylock
    swayidle

    # Apps
    brave

    # Nix tooling
    nix-tree
  ];

  # ── Git ───────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user.name = "tagbit26-sys";
      user.email = "tagbit26@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      credential.helper = "store";
    };
  };

  # ── Fish shell ────────────────────────────────────────────────────────────
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fastfetch
      if test (tty) = /dev/tty1
        exec Hyprland --i-am-really-stupid
      end
    '';
    shellAliases = {
      ls   = "eza --icons";
      ll   = "eza -lah --icons";
      cat  = "bat";
      hm   = "home-manager switch";
      mem  = "free -h";                        # quick RAM check
      top  = "btop";                           # always use btop
      diff = "diff --color=auto";
    };
  };

  # ── VSCode ────────────────────────────────────────────────────────────────
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

        # ── Performance tweaks ──
        "editor.renderWhitespace" = "none";
        "editor.minimap.enabled" = false;      # saves GPU/RAM
        "editor.smoothScrolling" = false;
        "workbench.enableExperiments" = false; # disable telemetry experiments
        "extensions.autoUpdate" = false;       # don't auto-update extensions
        "telemetry.telemetryLevel" = "off";
        "files.watcherExclude" = {
          "**/.git/objects/**" = true;
          "**/.git/subtree-cache/**" = true;
          "**/node_modules/**" = true;
          "**/__pycache__/**" = true;
          "**/.venv/**" = true;
        };
      };
    };
  };

  # ── Session Variables ─────────────────────────────────────────────────────
  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
    MOZ_ENABLE_WAYLAND = "1";         # native Wayland for browsers
    LIBVA_DRIVER_NAME = "iHD";        # Intel GPU hardware accel
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
    # ── Performance ──
    NIXPKGS_ALLOW_UNFREE = "1";
    XDG_CACHE_HOME = "$HOME/.cache";  # keep cache organized
  };

  # ── systemd user services — memory management ─────────────────────────────
  systemd.user.services.cleanup-cache = {
    Unit.Description = "Clean up old cache files";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'find ~/.cache -type f -atime +30 -delete'";
    };
  };

  systemd.user.timers.cleanup-cache = {
    Unit.Description = "Weekly cache cleanup";
    Timer = {
      OnCalendar = "weekly";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  # ── File links ────────────────────────────────────────────────────────────
  programs.home-manager.enable = true;
  home.file = {
    ".config/hypr/hyprland.conf".source = ./hyprland.conf;
    ".config/waybar/config".source = ./waybar/config;
    ".config/waybar/style.css".source = ./waybar/style.css;
  };
}
