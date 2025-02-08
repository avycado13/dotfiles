{
  config,
  inputs,
  pkgs,
  ...
}: {
  nix.settings.trusted-users = ["avy"];

  # age.secrets.hashedUserPassword = {
  #   file = "${inputs.secrets}/hashedUserPassword.age";
  # };

  users = {
    users = {
      avy = {
        shell = pkgs.zsh;
        uid = 1000;
        isNormalUser = true;
        # hashedPasswordFile = config.age.secrets.hashedUserPassword.path;
        extraGroups = [
          "wheel"
          "users"
          "video"
          "podman"
          "input"
        ];
        group = "avy";
        openssh.authorizedKeys.keys = [
          ""
        ];
      };
    };
    groups = {
      avy = {
        gid = 1000;
      };
    };
  };
  programs.zsh.enable = true;
}
