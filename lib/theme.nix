{lib, ...}: let
  # Solitude — https://github.com/HANCORE-linux/omarchy-solitude-theme
  theme = {
    base00 = "#101315"; # bg
    base01 = "#1e1e1e"; # darkest surface
    base02 = "#2f353b"; # surface / borders
    base03 = "#4b4e55"; # muted / comments
    base04 = "#707070"; # gray
    base05 = "#9fa5a9"; # mid fg
    base06 = "#cacccc"; # fg
    base07 = "#d9dbdc"; # light fg
    base08 = "#de6145"; # red / rust accent
    base09 = "#c9c2b4"; # warm sand
    base0A = "#cbc2be"; # beige
    base0B = "#9fa5a9"; # sage green
    base0C = "#a8adb0"; # light steel highlight
    base0D = "#798186"; # steel blue accent
    base0E = "#aeaeae"; # silver
    base0F = "#565d60"; # deep slate
  };

  stripHash = str:
    if builtins.substring 0 1 str == "#"
    then builtins.substring 1 (builtins.stringLength str - 1) str
    else str;

  themeNoHash = builtins.mapAttrs (_: v: stripHash v) theme;

  darken = percent: hex: let
    channel = offset: let
      value = lib.fromHexString (builtins.substring offset 2 (stripHash hex));
    in
      lib.toLower (lib.fixedWidthString 2 "0" (lib.toHexString (value * (100 - percent) / 100)));
  in "#${channel 0}${channel 2}${channel 4}";
  cursor = {
    name = "Bibata-Solitude";
    size = 24;
  };
in {
  flake = {
    inherit theme themeNoHash darken cursor;
  };
}
