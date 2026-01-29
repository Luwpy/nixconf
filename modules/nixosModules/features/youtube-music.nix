{
  flake.nixosModules.youtube-music = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.pear-desktop
      pkgs.spotify
    ];

    persistance.cache.directories = [
      ".config/YouTube Music"
    ];
  };
}
