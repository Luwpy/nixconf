{
  pkgs,
  lib,
  config,
  ...
}: let
  background = "rgb(" + config.lib.stylix.colors.base00 + ")";
in {
  imports = [
    ./bidings.nix
    ./animations.nix
    ./polkitagent.nix
  ];

  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6ct
    hyprshot
    hyprpicker
    swappy
    imv
    wf-recorder
    wlr-randr
    wl-clipboard
    brightnessctl
    gnome-themes-extra
    libva
    dconf
    wayland-utils
    wayland-protocols
    glib
    direnv
    meson
  ];

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

      exec-once = [
        "dbus-update-activation-environment --systemd --all &"
        "systemctl --user enable --now hyprpaper.service &"
      ];

      monitor = ["eDP-1,highres,auto,1"];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "ANKI_WAYLAND,1"
        "DISABLE_QT5_COMPAT,0"
        "NIXOS_OZONE_WL,1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM=wayland,xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "__GL_GSYNC_ALLOWED,0"
        "__GL_VRR_ALLOWED,0"
        "DISABLE_QT5_COMPAT,0"
        "DIRENV_LOG_FORMAT,"
        "WLR_DRM_NO_ATOMIC,1"
        "WLR_BACKEND,vulkan"
        "WLR_RENDERER,vulkan"
        "WLR_NO_HARDWARE_CURSORS,1"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
        "AQ_DRM_DEVICES,/dev/dri/card1" # CHANGEME: Related to the GPU
      ];

      cursor = {
        no_hardware_cursors = true;
        default_monitor = "eDP-1";
      };

      general = {
        resize_on_border = false;
        gaps_in = 10;
        gaps_out = 10 * 2;
        layout = "master";
        "col.inactive_border" = lib.mkForce background;
      };

      decoration = {
        active_opacity = 0.96;
        inactive_opacity = 0.92;
        rounding = 20;
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
        };
        blur = {
          enabled = true;
          size = 18;
        };
      };

      master = {
        new_status = true;
        allow_small_split = true;
        mfact = 0.5;
      };

      gestures = {workspace_swipe = true;};

      misc = {
        vfr = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = true;
        focus_on_activate = true;
        new_window_takes_over_fullscreen = 2;
      };

      windowrulev2 = [
        "float, tag:modal"
        "pin, tag:modal"
        "center, tag:modal"

        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"

        "idleinhibit focus, class:^(zen)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(zen)$"

        "dimaround, class:^(gcr-prompter)$"
        "dimaround, class:^(xdg-desktop-portal-gtk)$"
        "dimaround, class:^(polkit-gnome-authentication-agent-1)$"
        "dimaround, class:^(zen)$, title:^(File Upload)$"

        "rounding 0, xwayland:1"
      ];

      layerrule = ["noanim, launcher" "noanim, ^ags-.*"];

      input = {
        kb_layout = "br";

        kb_options = "caps:escape";
        follow_mouse = true;
        sensitivity = 0.5;
        repeat_delay = 500;
        repeat_rate = 50;
        numlock_by_default = true;
        force_no_accel = true;
      };
    };
  };
}
