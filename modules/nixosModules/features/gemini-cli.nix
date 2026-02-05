{...}: {
  flake.nixosModules.gemini-cli = {
    pkgs,
    lib,
    config,
    ...
  }: {
    environment.systemPackages = [
      pkgs.gemini-cli-bin
      pkgs.opencode
    ];
  };
}
