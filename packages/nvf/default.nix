{lib, ...}: let
  # Simple recursive module importer
  importModulesRecursive = dir: let
    entries = builtins.readDir dir;

    processEntry = name: type: let
      path = "${toString dir}/${name}";
    in
      if type == "directory" && builtins.pathExists "${path}/default.nix"
      then import path
      else if type == "regular" && name != "default.nix" && lib.hasSuffix ".nix" name
      then import path
      else null;

    modules = lib.mapAttrsToList processEntry entries;
  in
    lib.filter (x: x != null) modules;

  core = importModulesRecursive ./core;
  theme = importModulesRecursive ./theme;
  plugins = importModulesRecursive ./plugins;
in {
  imports = core ++ theme ++ plugins;
  vim.enableLuaLoader = true;
}
