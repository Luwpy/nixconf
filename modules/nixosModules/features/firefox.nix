{inputs, ...}: {
  flake.nixosModules.firefox = {pkgs, ...}: {
    programs.firefox.enable = true;

    environment.systemPackages = [inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".twilight];

    persistance.data.directories = [
      ".mozilla"
      ".zen"
    ];

    persistance.cache.directories = [
      ".cache/mozilla"
      ".cache/zen"
    ];

    preferences.keymap = {
      "SUPER + d"."f".package = pkgs.firefox;
    };
  };
}
