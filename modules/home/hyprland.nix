{
  config,
  lib,
  pkgs,
  ...
}: {
  # Remove the conditional - let this be enabled by the system module
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "DP-1,1920x1080@144,0x0,1"
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
        "float, ^(pavucontrol)$"
      ];

      "$mod" = "SUPER";

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, E, exec, nautilus"

        "$mod, Q, killactive"
        "$mod SHIFT, E, exit"
        "$mod, F, fullscreen"
        "$mod, P, pseudo"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Move focus with vim keys
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

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

        # Screenshot bindings
        ", Print, exec, grim ~/Pictures/screenshot-$(date +'%Y-%m-%d-%H%M%S').png"
        "$mod, Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +'%Y-%m-%d-%H%M%S').png"

        # Audio controls
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"

        # Manual audio controls (Alt + F keys as backup)
        "ALT, F12, exec, pamixer -i 5"
        "ALT, F11, exec, pamixer -d 5"
        "ALT, F10, exec, pamixer -t"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      exec-once = [
        "dunst"
        "discord"
        "vesktop"
      ];
    };
  };

  home.file."Pictures/.keep".text = "";

  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    dunst
    libnotify
    pamixer
  ];
}
