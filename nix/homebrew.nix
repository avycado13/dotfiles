{
  config,
  lib,
  pkgs,
  ...
}: {
  homebrew.enable = true;
  homebrew.brews = ["openssl" "wget" "git-secret"];
  homebrew.casks = ["arc" "visual-studio-code" "inkscape"];
  homebrew.masApps = {
    "Xcode" = 497799835;
  };
}
