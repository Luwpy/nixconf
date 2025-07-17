{ ...
}: let lib = import ./../../modules/flake/lib; 
      core = lib.importModulesRecursive ./core;
      theme = lib.importModulesRecursive ./theme;
      plugins = lib.importModulesRecursive ./plugins;
in {
  imports =  core ++ theme ++ plugins;
}
