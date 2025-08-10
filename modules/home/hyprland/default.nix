{
  pkgs,
  config,
  lib,
  ...
}:
let
  background = "rgb(" + config.lib.stylix.colors.base00 + ")";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      enable = false;
      variables = [
        "--all"
      ];
    };
    package = null;
    portalPackage = null;

    settings = {
      "$mod" = "SUPER";
      "$shiftMod" = "SUPER_SHIFT";

      monitor = [
        ",1920x1080@144,0x0,1"
      ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "NIXOS_OZONE_WL,1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "SDL_VIDEODRIVER,wayland"
      ];

      cursor = {
        no_hardware_cursor = true;
      };

      general = {
        resize_on_border = true;
        gaps_in = 10;
        gaps_out = 5;
        border_size = "10px";
        layout = "master";
        "col.inactive_border" = lib.mkForce background;
      };

      decoration = {
        active_opacity = active-opacity;
        inactive_opacity = inactive-opacity;
        rounding = rounding;
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
        };
        blur = {
          enabled = false;
          size = 18;
        };
      };
    };
  };
}
