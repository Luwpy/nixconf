{...}: let
  theme = {
    base00 = "#232136"; # bg – surface
    base01 = "#2a273f"; # overlay / subtle
    base02 = "#393552"; # muted / highlight
    base03 = "#59546d"; # comments / disabled
    base04 = "#817c9c"; # dimmed foreground
    base05 = "#e0def4"; # main foreground / text
    base06 = "#f0f0f3"; # light foreground (bright text)
    base07 = "#c4a7e7"; # special / lavender
    base08 = "#eb6f92"; # red / love
    base09 = "#f6c177"; # orange / gold
    base0A = "#f6c177"; # yellow (same as gold in Rose Pine)
    base0B = "#3e8fb0"; # green / pine (slightly brighter than Main)
    base0C = "#9ccfd8"; # cyan / foam
    base0D = "#9ccfd8"; # blue / iris (commonly mapped to foam)
    base0E = "#c4a7e7"; # magenta / lilac
    base0F = "#f6c177"; # alternative orange (matches base09)
  };

  stripHash = str:
    if builtins.substring 0 1 str == "#"
    then builtins.substring 1 (builtins.stringLength str - 1) str
    else str;

  themeNoHash = builtins.mapAttrs (_: v: stripHash v) theme;
in {
  flake = {
    inherit theme themeNoHash;
  };
}
