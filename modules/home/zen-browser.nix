{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.zen-browser.homeModules.twilight];
  programs.zen-browser = {
    enable = true;
  };
}
