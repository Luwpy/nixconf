{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.gaming;
in {
  options.modules.gaming = {
    enable = lib.mkEnableOption "gaming";

    steam.enable = lib.mkEnableOption "Steam and configuration";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      steam = {
        enable = cfg.steam.enable;
        remotePlay.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
