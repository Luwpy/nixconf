{
  flake.nixosModules.fonts = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      corefonts
      noto-fonts
      lexend
      garamond-libre
      (pkgs.stdenv.mkDerivation {
        pname = "custom-fonts";
        version = "1.0";
        src = ../../../assets/fonts;
        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          cp $src/* $out/share/fonts/truetype/
        '';
      })
    ];
  };
}
