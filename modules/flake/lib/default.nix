{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  flake.lib = {
    importModulesRecursive = let
      mapModules = dir: fn:
        lib.pipe dir [
          builtins.readDir
          (lib.mapAttrs' (n: v: let
            path = "${toString dir}/${n}";
          in
            if v == "directory" && builtins.pathExists "${path}/default.nix"
            then lib.nameValuePair n (fn path)
            else if v == "directory"
            then lib.nameValuePair n (mapModules path fn)
            else if v == "regular" && n != "default.nix" && lib.hasSuffix ".nix" n
            then lib.nameValuePair (lib.removeSuffix ".nix" n) (fn path)
            else lib.nameValuePair "" null))
        ];

      flatten = attrs: lib.collect (x: !lib.isAttrs x) attrs;
    in
      dir: flatten (mapModules dir (x: x));
  };
}
