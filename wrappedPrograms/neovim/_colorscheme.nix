{darken}: let
  inherit (builtins) concatStringsSep;

  # Ashen — https://github.com/ficd0/ashen.nvim
  theme = {
    base00 = "#121212"; # bg
    base01 = "#191919"; # darkest surface
    base02 = "#323232"; # surface / borders
    base03 = "#535353"; # muted / comments
    base04 = "#737373"; # gray
    base05 = "#949494"; # mid fg
    base06 = "#b4b4b4"; # fg
    base07 = "#e5e5e5"; # light fg
    base08 = "#DF6464"; # red glow accent
    base09 = "#D87C4A"; # orange glow
    base0A = "#E5A72A"; # golden
    base0B = "#629C7D"; # light green
    base0C = "#3A6E6E"; # dark teal
    base0D = "#4A8B8B"; # muted teal blue
    base0E = "#D1728C"; # rose pink
    base0F = "#C4693D"; # blaze orange
  };

  palette =
    theme
    // {
      green = theme.base0B;
      cyan = theme.base0C;
      blue2 = darken 25 theme.base0D;

      bg = theme.base00;
      fg = theme.base06;
      orange = theme.base09;
      red = theme.base08;
      blue = theme.base0D;
      yellow = theme.base0A;
      magenta = theme.base0E;

      gray = theme.base01;
      lightgray = theme.base02;
      darkgray = darken 15 theme.base00;
      inactivegray = darken 30 theme.base00;
    };

  groups = [
    [
      "base00"
      "base01"
      "base02"
      "base03"
      "base04"
      "base05"
      "base06"
      "base07"
      "base08"
      "base09"
      "base0A"
      "base0B"
      "base0C"
      "base0D"
      "base0E"
      "base0F"
    ]
    [
      "green"
      "cyan"
      "blue2"
    ]
    [
      "bg"
      "fg"
      "orange"
      "red"
      "blue"
      "yellow"
      "magenta"
      "gray"
      "lightgray"
      "darkgray"
      "inactivegray"
    ]
  ];

  entry = name: "    ${name} = \"${palette.${name}}\",";

  renderGroup = names: concatStringsSep "\n" (map entry names);
in
  concatStringsSep "\n" [
    "local COLORSCHEME = {"
    (concatStringsSep "\n\n" (map renderGroup groups))
    "}"
    ""
    "return COLORSCHEME"
    ""
  ]
