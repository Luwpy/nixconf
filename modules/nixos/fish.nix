{
  pkgs,
  username,
  lib,
  config,
  ...
}: let
  cfg = config.modules.fish;
in {
  options.modules.fish = {
    enable = lib.mkEnableOption "fish";

    shellInit = lib.mkOption {
      type = lib.types.str;
      default = '''';
      example = ''
        neofetch
      '';
    };
  };

  config = {
    users.users.${username} = {
      shell = pkgs.fish;
    };

    programs.fish = {
      enable = true;
      shellInit = '''' ++ cfg.shellInit;
    };
  };
}
