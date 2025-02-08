inputs: let
  homeManagerCfg = userPackages: extraImports: {
    home-manager.useGlobalPkgs = false;
    home-manager.extraSpecialArgs = {
      inherit inputs;
    };
    home-manager.users.avy.imports =
      [
        inputs.agenix.homeManagerModules.default
        inputs.mac-app-util.homeManagerModules.default
        inputs.nix-index-database.hmModules.nix-index
        ./users/avy/dots.nix
        ./users/avy/age.nix
      ]
      ++ extraImports;
    home-manager.backupFileExtension = "bak";
    home-manager.useUserPackages = userPackages;
  };
in {
  mkDarwin = machineHostname: nixpkgsVersion: extraHmModules: extraModules: {
    darwinConfigurations.${machineHostname} = inputs.nix-darwin.lib.darwinSystem {
      system = builtins.currentSystem or "aarch64-darwin"; # Default to ARM but can be overridden
      specialArgs = {
        inherit inputs;
      };
      modules = [
        "${inputs.secrets}/default.nix"
        inputs.agenix.darwinModules.default
        ./machines/darwin
        ./machines/darwin/${machineHostname}
        inputs.mac-app-util.darwinModules.default
        inputs.home-manager-darwin.darwinModules.home-manager
        inputs.nix-index-database.darwinModules.nix-index
        {
          home-manager.users.avy.home.homeDirectory = inputs.nixpkgs-darwin.lib.mkForce "/Users/avy";
        }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "avy";
            autoMigrate = true;
          };
        }
        (inputs.nixpkgs-darwin.lib.attrsets.recursiveUpdate (homeManagerCfg true extraHmModules) {
          })
      ];
    };
  };
  mkNixos = machineHostname: nixpkgsVersion: extraModules: rec {
    deploy.nodes.${machineHostname} = {
      hostname = machineHostname;
      profiles.system = {
        user = "root";
        sshUser = "avy";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos nixosConfigurations.${machineHostname};
      };
    };
    apps = nixinate.nixinate.x86_64-linux self;
    nixosConfigurations.${machineHostname} = nixpkgsVersion.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        vars = import ./machines/nixos/vars.nix;
      };
      modules =
        [
          ./homelab
          ./machines/nixos/_common
          ./machines/nixos/${machineHostname}
          ./modules/email
          ./modules/tg-notify
          ./modules/duckdns
          ./modules/auto-aspm
          ./modules/mover
          "${inputs.secrets}/default.nix"
          "${inputs.nix-mineral}/nix-mineral.nix"
          inputs.agenix.nixosModules.default
          inputs.nix-topology.nixosModules.default
          ./users/avy
          (homeManagerCfg false [])
        ]
        ++ extraModules;
    };
  };
  mkPod = name: containers: extraSpec:
    kubenix.evalModules.${system} {
      module = {kubenix, ...}: {
        imports = [kubenix.modules.k8s];
        kubernetes.resources.pods.${name}.spec =
          {
            containers = builtins.listToAttrs (map (c: {
                name = c.name;
                value =
                  {
                    image = c.image;
                    resources = c.resources or {};
                  }
                  // (c.extraConfig or {});
              })
              containers);
          }
          // extraSpec;
      };
    };

  mkMerge = inputs.nixpkgs.lib.lists.foldl' (
    a: b: inputs.nixpkgs.lib.attrsets.recursiveUpdate a b
  ) {};
}
