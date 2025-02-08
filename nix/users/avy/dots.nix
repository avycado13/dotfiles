{...}: let
  home = {
    username = "avy";
    homeDirectory = "/home/avy";
    stateVersion = "24.11";
  };
in {
  nixpkgs = {
    overlays = [nix-topology.overlays.default];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = home;

  imports = [
    ../../dotfiles/zsh/default.nix
    # ../../dots/nvim/default.nix
    ../../dotfiles/neofetch/default.nix
    ./packages.nix
    ./gitconfig.nix
  ];

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";
}
