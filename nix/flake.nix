{
  # Inputs for dependencies: Nixpkgs and Home Manager
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";  # Standard Nix package set
    home-manager = {
      url = "github:nix-community/home-manager";  # Home Manager for user configurations
      inputs.nixpkgs.follows = "nixpkgs";  # Use the same Nixpkgs version
    };
  };

  # Outputs: Define system and Home Manager configurations
  outputs = { self, nixpkgs, home-manager }: {
    # Home Manager configurations for the current user
    homeConfigurations = {
      # Replace "avy" with your actual username
      avy = home-manager.lib.homeManagerConfiguration {
        # Set package set for Home Manager
        pkgs = nixpkgs.legacyPackages.x86_64-darwin;

        # Basic Home Manager setup
        home = {
          username = "avy";  # Replace with your username
          homeDirectory = "/Users/avy";  # Adjust to your home directory
          stateVersion = "24.11";  # Match your Nixpkgs version

          # Add persistent packages using `home.packages`
          packages = [
            nixpkgs.legacyPackages.x86_64-darwin.git  # Explicitly use `nixpkgs.legacyPackages`
            nixpkgs.legacyPackages.x86_64-darwin.neovim  # Explicitly use `nixpkgs.legacyPackages`
          ];

          # Optional: Enable and configure Neovim
          programs.neovim = {
            enable = true;
          };

          # Additional configuration goes here
        };
      };
    };
  };
}
