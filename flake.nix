{
  description = "Cory's declarative macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nix-darwin, home-manager, ... }:
    let
      mkDarwin =
        { hostName, userName }:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs hostName userName; };
          modules = [
            ./configuration.nix
            home-manager.darwinModules.home-manager
          ];
        };
    in
    {
      darwinConfigurations = {
        macos-vm = mkDarwin {
          hostName = "macos-config-vm";
          userName = "cory";
        };

        macbook = mkDarwin {
          hostName = "cory-mac";
          userName = "cory.hernandez";
        };
      };
    };
}
