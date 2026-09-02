{
  flake.nixosModules.youtube-music = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.pear-desktop
    ];

    persistance.cache.directories = [
      ".config/YouTube Music"
    ];
  };

  flake.nixosModules.spotify = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      spotify
    ];
  };
}
