{
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.disko;
  fileSystems = {
    athena = import ./athena.nix;
  };
in {
  imports = [inputs.disko.nixosModules.disko];
  options.modules.disko = {
    enable = lib.mkEnableOption "disko module";
    device = lib.mkOption {
      type = lib.types.str;
      default = null;
    };
    swapSizeInGb = lib.mkOption {
      type = with lib; types.nullOr types.str;
      default = "4G";
    };
    fileSystem = lib.mkOption {
      type = lib.types.enum (lib.attrNames fileSystems);
      default = "athena";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.device != null;
        message = "The option 'devices' must be set";
      }
      {
        assertion = lib.hasAttr cfg.fileSystem fileSystems;
        message = "The 'fileSystem' option in 'modules.disko' must be a valid filesystem";
      }
    ];

    disko = fileSystems.${cfg.fileSystem} {
      inherit lib;
      inherit (cfg) device swapSizeInGb;
    };
  };
}
