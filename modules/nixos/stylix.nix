{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.stylix;
in {
  imports = [inputs.stylix.nixosModules.stylix];

  options.modules.stylix = {
    enable = lib.mkEnableOption "stylix system theming";

    image = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Wallpaper image to generate colorscheme from";
    };

    base16Scheme = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = null;
      description = "Base16 color scheme";
    };

    polarity = lib.mkOption {
      type = lib.types.enum [
        "light"
        "dark"
      ];
      default = "dark";
      description = "Theme polarity";
    };

    autoEnable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically enable styling for detected programs";
    };

    fonts = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Font configuration";
    };

    cursor = lib.mkOption {
      type = lib.types.attrs;
      default = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };
      description = "Cursor configuration";
    };

    targets = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Target-specific styling options";
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = cfg.autoEnable;
      image = lib.mkIf (cfg.image != null) cfg.image;
      base16Scheme = lib.mkIf (cfg.base16Scheme != null) cfg.base16Scheme;
      polarity = cfg.polarity;
      fonts = cfg.fonts;
      cursor = cfg.cursor;
      targets = cfg.targets;
    };
  };
}
