{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  age.secrets.gitIncludes = {
    file = "${inputs.secrets}/gitIncludes.age";
    path = "$HOME/.config/git/includes";
  };
  programs.git = {
    enable = true;
    userName = "avycado13";
    userEmail = "108358183+avycado13@users.noreply.github.com.";
    aliases = {
      st = "status";
    };
    package = pkgs.gitFull;
    extraConfig = {
      # trailer "changeid" = {
      #   key = "Change-Id";
      # };
      color = {
        ui = "auto";
      };
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
      pull = {
        rebase = false;
      };
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };
}
