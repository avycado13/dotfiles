{
  description = "Darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, ... }: {
    darwinConfigurations = {
      hostname = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.avy = import ./home.nix;
          }
        ];
      };
    };

    # Expose the configuration for darwin-rebuild
    packages = {
      aarch64-darwin = {
        darwinConfigurations = {
          "Avys-Mac" = darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            modules = [
              ./configuration.nix  # Make sure this path is correct
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.avy = import ./home.nix;
              }
              nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = {
                  # Install Homebrew under the default prefix
                  enable = true;

                  # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                  enableRosetta = true;

                  # User owning the Homebrew prefix
                  user = "avy";

                  # Automatically migrate existing Homebrew installations
                  autoMigrate = true;
                };
              }
            ];
          };
        };
      };
    };
  };
}