{self, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages.default =
      (self.inputs.nvf.lib.neovimConfiguration {
        pkgs = self.inputs.nixpkgs.legacyPackages.${system};
        modules = [../../../packages/nvf];
      }).neovim;
  };
}
