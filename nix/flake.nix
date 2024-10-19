{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # system level configuration
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixpkgs-unstable,
    nix-darwin,
    ...
  }: let
    arch = "aarch64-darwin"; # or aarch64-darwin
  in {
    defaultPackage.${arch} =
      home-manager.defaultPackage.${arch};

    # Add nix-darwin configuration
    darwinConfigurations = {
      scotts-MacBook-Air = nix-darwin.lib.darwinSystem {
        system = arch;
        modules = [
          ./darwin-configuration.nix # your configuration for macOS
          home-manager.darwinModules.home-manager
        ];
        pkgs = import nixpkgs {system = arch;}; # for Mac with ARM chip
        specialArgs = {inherit nix-darwin;};
      };
    };

    homeConfigurations.scott =
      # REPLACE ME
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${arch};
        modules = [./home.nix];
        extraSpecialArgs = {
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${arch};
        };
      };

    # Make nix-darwin available for nix run
    defaultApp = {
      type = "app";
      program = "${nix-darwin}/bin/darwin-rebuild";
    };
  };
}
