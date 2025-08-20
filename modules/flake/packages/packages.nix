{self, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages.neovim =
      (self.inputs.nvf.lib.neovimConfiguration {
        pkgs = self.inputs.nixpkgs.legacyPackages.${system};
        modules = [../../../packages/nvf];
      }).neovim;
  };
}
