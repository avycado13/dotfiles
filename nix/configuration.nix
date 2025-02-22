{
  config,
  pkgs,
  ...
}: {
  # System-wide defaults
  system = {
    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        mineffect = "genie";
        mru-spaces = false;
      };

      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        _FXShowPosixPathInTitle = true;
      };

      # Trackpad settings
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
    };

    # System-wide keyboard settings
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  # System-level packages
  environment.systemPackages = with pkgs; [
    # Development tools
    git
    neovim
    curl
    wget

    # System utilities
    coreutils
    htop
    tree
    # misc stuff that every one needs!
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
  ];

  # Enable zsh
  programs.zsh.enable = true;
  programs.direnv.enable = true;
  # Security settings
  security.pam.enableSudoTouchIdAuth = true;

  # Network settings
  networking = {
    computerName = "Avys-MacBook-Air";
    hostName = "Avys-Mac";
    localHostName = "Avys-Mac";
  };

  # Nix settings
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };

  # Nix Darwin version
  system.stateVersion = 4;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # User settings
  users.users.avy = {
    name = "avy";
    home = "/Users/avy";
    shell = pkgs.zsh;
  };
}
