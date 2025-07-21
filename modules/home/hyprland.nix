{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.anyrun.homeManagerModules.anyrun ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        ",preferred,auto,auto"
      ];

      input = {
        kb_layout = "br";
        follow_mouse = 1;
        sensitivity = 0;
        force_no_accel = 1;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
      };

      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
        };
        drop_shadow = false;
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 4, myBezier"
          "windowsOut, 1, 4, default, popin 80%"
          "border, 1, 5, default"
          "fade, 1, 4, default"
          "workspaces, 1, 3, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      windowrule = [
        # "float, ^(pavucontrol)$"
      ];

      "$mod" = "SUPER";

      bind = [
        # Application bindings
        "$mod, Return, exec, kitty"
        "$mod, E, exec, nautilus"

        # Window management
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, P, pseudo"

        # Hyprland control - QUIT BINDINGS
        "$mod SHIFT, E, exit"
        "$mod SHIFT CTRL, Q, exec, hyprctl dispatch exit"
        "$mod SHIFT, Q, exec, pkill Hyprland"

        # Focus movement
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Focus movement with vim keys
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Move windows
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        # Move windows with vim keys
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Screenshot bindings - to clipboard
        ", Print, exec, grim - | wl-copy"
        "$mod, Print, exec, grim -g \"$(slurp)\" - | wl-copy"

        # Screenshot bindings - save to file (if you still want this option)
        "$mod SHIFT, Print, exec, grim ~/Pictures/screenshot-$(date +'%Y-%m-%d-%H%M%S').png"
        "$mod CTRL, Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +'%Y-%m-%d-%H%M%S').png"

        # Anyrun launcher
        "$mod, R, exec, anyrun"

        # Audio controls
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"

        # Manual audio controls (Alt + F keys as backup)
        "ALT, F12, exec, pamixer -i 5"
        "ALT, F11, exec, pamixer -d 5"
        "ALT, F10, exec, pamixer -t"

        # Lock screen
        "$mod CTRL, L, exec, swaylock"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      exec-once = [
        # Initialize swww daemon and set wallpaper
        "swww-daemon && sleep 2 && swww img /persist/nixconf/wallpaper/wallpaper.gif --transition-type fade --transition-duration 2"

        # Other startup apps
        "dunst"
      ];
    };
  };

  # Simple package list with swww
  home.packages = with pkgs; [
    # Wallpaper daemon
    swww

    # Screenshot tools
    grim
    slurp
    wl-clipboard

    # Notifications
    dunst
    libnotify

    # Audio
    pamixer

    # Lock screen
    swaylock

    # File manager
    nautilus
  ];

  programs.anyrun = {
    enable = lib.mkForce true;
    config = {
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.3;
      };
      width = {
        fraction = 0.3;
      };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;

      plugins = [
        # An array of all the plugins you want, which either can be paths to the .so files, or their packages
        "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/kidex"
      ];
    };

    # Inline comments are supported for language injection into
    # multi-line strings with Treesitter! (Depends on your editor)

  };

  # Create Pictures directory
  home.file."Pictures/.keep".text = "";
}
