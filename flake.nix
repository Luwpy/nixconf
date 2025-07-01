{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter.url = "github:numtide/nixos-facter-modules";

    devshell.url = "github:numtide/devshell";
    disko.url = "github:nix-community/disko";

    sops-nix.url = "github:Mic92/sops-nix";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    stylix.url = "github:danth/stylix";
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
