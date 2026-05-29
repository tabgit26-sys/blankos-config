{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home.username = "blank";
  home.homeDirectory = "/home/blank";
  home.stateVersion = "26.05";

  # ── Packages ────────────────────────────────
  home.packages = with pkgs; [
    # Utils
    git btop ripgrep fd bat eza fzf
    unzip wget curl less jq fastfetch
    linuxPackages.cpupower

    # Wayland / desktop
    wofi wl-clipboard grim slurp
    swaylock swayidle

    # Nix tooling
    nix-tree
  ];

  # ── Git ─────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user.name = "tabgit26-sys";
      user.email = "tabgit26@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      credential.helper = "store";
    };
  };

  # ── Fish shell ───────────────────────────────
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
      hm   = "home-manager switch --flake ~/.config/home-manager";
      mem  = "free -h";
      top  = "btop";
      diff = "diff --color=auto";
      backup = "~/backup.sh";
      # Profile switchers
      minimal = "home-manager switch --flake ~/.config/home-manager#blank-minimal";
      dev     = "home-manager switch --flake ~/.config/home-manager#blank-dev";
      ml      = "home-manager switch --flake ~/.config/home-manager#blank-ml";
      full    = "home-manager switch --flake ~/.config/home-manager#blank-full";
    };
  };

  # ── Session Variables ────────────────────────
  home.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
    MOZ_ENABLE_WAYLAND = "1";
    LIBVA_DRIVER_NAME = "iHD";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
    NIXPKGS_ALLOW_UNFREE = "1";
    XDG_CACHE_HOME = "$HOME/.cache";
  };

  # ── Cache cleanup ────────────────────────────
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

  # ── File links ───────────────────────────────
  programs.home-manager.enable = true;
  home.file = {
    ".config/hypr/hyprland.conf".source = ./hyprland.conf;
    ".config/waybar/config".source = ./waybar/config;
    ".config/waybar/style.css".source = ./waybar/style.css;
  };
}
