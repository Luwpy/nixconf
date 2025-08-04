{
  pkgs,
  username,
  lib,
  config,
  ...
}:
{

  programs.fish = {
    enable = true;
    shellInit = ''
      nerdfetch

      zoxide init fish --cmd cd | source
    '';

  };

  programs = {
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      flags = [ "--cmd cd" ];
    };

    bat.enable = true;
  };

  packages = with pkgs; [
    eza
    nerdfetch
  ];
}
