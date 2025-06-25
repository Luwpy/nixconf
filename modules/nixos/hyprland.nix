{
  config,
  pkgs,
  inputs,
  lib,
  username,
  ...
}: let
  cfg = config.modules.hyprland;
in {
  options.modules.hyprland = {
    enable = lib.mkEnableOption "hyprland";

    xwayland.enable = lib.mkEnableOption "Xwayland";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.hyprland;
      description = "Hyprland package";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = cfg.package;
      xwayland.enable = cfg.xwayland.enable;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.commom.default = "*";
    };

    security = {
      polkit.enable = true;
    };

    services = {
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
            user = "greeter";
          };
        };
      };
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";

      XCURSOR_SIZE = "24";
    };

    users.users.${username}.extraGroups = [
      "audio"
      "video"
      "input"
      "render"
    ];
  };
}
