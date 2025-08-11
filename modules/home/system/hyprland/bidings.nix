{pkgs, ...}: {
  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mod,RETURN,exec, uwsm app -- ${pkgs.kitty}/bin/kitty"
      "$mod,E, exec,  uwsm app -- ${pkgs.xfce.thunar}/bin/thunar" # Thunar
      "$mod,B, exec,  uwsm app -- zen-beta" # Zen Browser
      "$mod,L, exec,  uwsm app -- ${pkgs.hyprlock}/bin/hyprlock"
      "$mod,SPACE, exec, menu" # Launcher
      "$mod,C, exec, quickmenu" # Quickmenu

      "$mod,Q, killactive," # Close window
      "$mod,T, togglefloating," # Toggle Floating
      "$mod,F, fullscreen" # Toggle Fullscreen
      "$mod,left, movefocus, l" # Move focus left
      "$mod,right, movefocus, r" # Move focus Right
      "$mod,up, movefocus, u" # Move focus Up
      "$mod,down, movefocus, d" # Move focus Down
      #"$shiftMod,up, focusmonitor, -1" # Focus previous monitor
      #"$shiftMod,down, focusmonitor, 1" # Focus next monitor
      "$shiftMod,left, layoutmsg, addmaster" # Add to master
      "$shiftMod,right, layoutmsg, removemaster" # Remove from master
      "$mod,PRINT, exec, screenshot region" # Screenshot region
      ",PRINT, exec, screenshot monitor" # Screenshot monitor
      "$shiftMod,PRINT, exec, screenshot window" # Screenshot window
      "ALT,PRINT, exec, screenshot region swappy" # Screenshot region then edit
    ];
  };
}
