{
  inputs,
  lib,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: let
    runtimePkgs = [];

    unwrapped = pkgs.rustPlatform.buildRustPackage {
      pname = "leaf";
      version = "1.28.2";

      src = lib.fileset.toSource {
        root = ./.;
        fileset =
          lib.fileset.unions [./Cargo.toml ./Cargo.lock ./src ./completions ./config.toml];
      };

      cargoLock.lockFile = ./Cargo.lock;

      nativeBuildInputs = [pkgs.pkg-config pkgs.installShellFiles];
      buildInputs = [pkgs.oniguruma];

      preCheck = ''
        export HOME=$(mktemp -d)
      '';

      postInstall = ''
        installShellCompletion --cmd leaf \
          --bash $src/completions/leaf.bash \
          --fish $src/completions/leaf.fish \
          --zsh $src/completions/leaf.zsh
      '';

      meta = {
        description = "Terminal Markdown previewer with a GUI-like experience";
        mainProgram = "leaf";
      };
    };
  in {
    packages.leaf = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package = unwrapped;
      binName = "leaf";
      inherit runtimePkgs;
    };

    devShells.leaf = self.lib.rustShell pkgs runtimePkgs;
  };
}
