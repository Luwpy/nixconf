{
  modules.nixos.desktop = {pkgs, ...}: {
    programs.chromium.enable = false;

    environment.systemPackages = [
      pkgs.ungoogled-chromium
    ];

    persistence.cache.directories = [
      ".config/chromium"
    ];
  };
}
