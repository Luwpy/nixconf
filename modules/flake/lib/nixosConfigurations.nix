{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  flake.nixosConfigurations = let
    mkConfig = {
      hostFile,
      system ? "x86_64-linux",
      username ? "luwpy",
    }:
      lib.nixosSystem {
        specialArgs = {
          inherit inputs username;
        };
        inherit system;
        modules = [hostFile];
      };

    configs = builtins.listToAttrs (map (hostFile: {
        name = lib.removeSuffix ".nix" (builtins.baseNameOf hostFile);
        value = mkConfig {
          inherit hostFile;
          # Add any default configuration here
        };
      })
      (lib.fileset.toList ../hosts));
  in
    lib.recursiveUpdate configs {
      # For other specific configurations
    };
}
