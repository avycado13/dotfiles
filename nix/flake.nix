{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    charmbracelet-nur.url = "github:charmbracelet/nur";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-darwin.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-darwin;
    in pkgs.buildEnv {
      name = "home-packages";
      paths = with pkgs; [
        # general tools
        git

        # ... add your tools here
      ];
    };
  };
}

