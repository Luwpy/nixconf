{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.sddm;

  foreground = config.lib.stylix.colors.base01;

  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
    themeConfig = {
      HeaderTextColor = "#${foreground}";
      DateTextColor = "#${foreground}";
      TimeTextColor = "#${foreground}";
      LoginFieldTextColor = "#${foreground}";
      PasswordFieldTextColor = "#${foreground}";
      UserIconColor = "#${foreground}";
      PasswordIconColor = "#${foreground}";
      WarningColor = "#${foreground}";
      LoginButtonBackgroundColor = "#${foreground}";
      SystemButtonsIconsColor = "#${foreground}";
      SessionButtonTextColor = "#${foreground}";
      VirtualKeyboardButtonTextColor = "#${foreground}";
      DropdownBackgroundColor = "#${foreground}";
      HighlightBackgroundColor = "#${foreground}";
      Background = "${toString config.stylix.image}";
    };
  };
in {
  options.modules.sddm = {
    enable = lib.mkEnableOption "sddm";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      package = pkgs.kdePackages.sddm;
      extraPackages = [sddm-astronaut];
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      settings = {
        Wayland.SessionDir = "${inputs.hyprland.packages."${pkgs.system}".hyprland}/share/wayland-sessions";
      };
    };

    environment.systemPackages = [sddm-astronaut];
  };
}
