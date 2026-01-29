{
  flake.nixosModules.gtk = {
    pkgs,
    lib,
    ...
  }: let
    inherit (lib) mkDefault;

    theme-name = "rose-pine-moon";
    theme-package = pkgs.rose-pine-gtk-theme;

    icon-theme-package = pkgs.numix-icon-theme-circle;
    icon-theme-name = "Numix-Circle";

    gtksettings = ''
      [Settings]
      gtk-icon-theme-name=${icon-theme-name}
      gtk-theme-name=${theme-name}
      gtk-application-prefer-dark-theme=1
    '';
  in {
    environment = {
      etc = {
        "xdg/gtk-3.0/settings.ini".text = gtksettings;
        "xdg/gtk-4.0/settings.ini".text = gtksettings;
      };
    };

    environment.variables = {
      GTK_THEME = "${theme-name}";
    };

    programs = {
      dconf = {
        enable = mkDefault true;
        profiles = {
          user = {
            databases = [
              {
                lockAll = false;
                settings = {
                  "org/gnome/desktop/interface" = {
                    gtk-theme = theme-name;
                    icon-theme = icon-theme-name;
                    color-scheme = "prefer-dark";
                  };
                };
              }
            ];
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      theme-package
      icon-theme-package

      gtk3
      gtk4
    ];
  };
}
