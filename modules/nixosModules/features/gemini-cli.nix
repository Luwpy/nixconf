{...}: {
  flake.nixosModules.gemini-cli = {
    pkgs,
    lib,
    config,
    ...
  }: {
    environment.systemPackages = [
      pkgs.gemini-cli-bin
      pkgs.claude-code
    ];

    persistance.data.directories = [
    ".claude"
    ];

    persistance.cache.directories = [
    ".cache/claude"
    ];
  };
}
