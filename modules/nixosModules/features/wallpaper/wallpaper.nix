{
  flake.nixosModules.wallpaper = {
    pkgs,
    lib,
    ...
  }: let
    inherit (lib) getExe;
  in {
    preferences.autostart = [
      # Wallpaper managed by Noctalia via settings
    ];
  };
}
