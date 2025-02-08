{
  inputs,
  pkgs,
  lib,
  ...
}: {
  homebrew.enable = true;
  homebrew.onActivation.autoUpdate = true;
  homebrew.brews = ["openssl" "wget" "git-secret" "cmus"];
  homebrew.casks = ["arc" "visual-studio-code" "inkscape" "blender"];
  homebrew.masApps = {
    "Xcode" = 497799835;
  };

  # System-level packages
  environment.systemPackages = with pkgs; [
    # Development tools
    git
    neovim
    curl
    wget
    comma

    # System utilities
    coreutils
    htop
    tree
    # misc stuff that everyone needs!
    cowsay
    file
    which
    gnused
    gnutar
    gawk
    zstd
    gnupg
    ripgrep
  ];

  # Enable zsh
  programs.zsh.enable = true;
  # Enable direnv
  programs.direnv.enable = true;
  # Security settings
  security.pam.enableSudoTouchIdAuth = true;

  # Network settings
  networking = {
    computerName = "Avyays MacBook Air";
    hostName = "Avys-Mac";
    localHostName = "Avys-Mac";
  };

  # Nix Darwin version
  system.stateVersion = 4;

  # User settings
  users.users.avy = {
    name = "avy";
    home = "/Users/avy";
    shell = pkgs.zsh;
  };
}
