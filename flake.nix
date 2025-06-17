{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter.url = "github:numtide/nixos-facter-modules";

    devshell.url = "github:numtide/devshell";
  };

  outputs = {self, ...} @ inputs: let
    importFlakeParts =
      (import ./modules/flake/lib {inherit self inputs;})
      .flake
      .lib
      .importModulesRecursive;
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = importFlakeParts ./modules/flake;

      systems = ["x86_64-linux"];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };
    };
}
