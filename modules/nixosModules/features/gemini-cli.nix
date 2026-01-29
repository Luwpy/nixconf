{inputs, ...}: {
  flake.nixosModules.gemini-cli = {
    pkgs,
    lib,
    config,
    ...
  }: {
    nixpkgs.overlays = [inputs.claude-code.overlays.default];
    environment.systemPackages = [
      pkgs.gemini-cli-bin
      pkgs.claude-code-bun
    ];
  };
}
