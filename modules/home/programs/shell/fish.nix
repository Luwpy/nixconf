{
  pkgs,
  username,
  lib,
  config,
  ...
}: {
  programs.fish = {
    enable = true;
    shellInit = ''
      zoxide init fish --cmd cd | source

      nerdfetch
    '';

    shellAbbrs = {
      vim = "nvim";
      vi = "nvim";
      ls = "eza --icons=always --no-quotes";
      tree = "eza --icons=always --no-quotes --tree";
      open = "${pkgs.xdg-utils}/bin/xdg-open";
      icat = "${pkgs.kitty}/bin/kitty +kitten icat";
      bat = "${pkgs.bat}/bin/bat --theme=base16 --color=always --paging=never --tabs=2 --wrap=never --plain";
      mkdir = "mkdir -p";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  home.packages = with pkgs; [
    eza
    bat
  ];
}
