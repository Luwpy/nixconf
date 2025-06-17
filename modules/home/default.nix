{
  inputs,
  config,
  lib,
  username,
  ...
}: let
  cfg = config.modules.home;
in {
  imports = [inputs.home-manager.nixosModules.default];

  options.modules.home = {
    enable = lib.mkEnableOption "home-manager module";

    username = lib.mkOption {
      type = lib.types.str;
      default = username;
      description = "The username for the home-manager user. Defaults to the username argument from the host module.";
    };

    directory = lib.mkOption {
      type = lib.types.str;
      default = "/home/${username}";
      description = "The home directory for the user.";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      default = config.system.stateVersion;
      description = "The home-manager state version. Defaults to system.stateVersion.";
    };

    useGlobalPkgs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use global nixpkgs for home-manager.";
    };

    useUserPackages = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install packages to user profile.";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "List of packages to install for the user.";
    };

    modules = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [];
      description = "Additional home-manager modules to import.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.username != null;
        message = "The 'username' option in 'modules.home' must be set.";
      }
    ];

    home-manager = {
      useGlobalPkgs = cfg.useGlobalPkgs;
      useUserPackages = cfg.useUserPackages;
      extraSpecialArgs = {
        inherit inputs username;
      };

      users.${cfg.username} = {
        imports = cfg.modules;

        home = {
          username = cfg.username;
          homeDirectory = cfg.directory;
          stateVersion = cfg.stateVersion;
          packages = cfg.packages;
        };

        programs.home-manager.enable = true;
      };
    };
  };
}
