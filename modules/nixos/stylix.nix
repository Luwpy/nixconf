{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [inputs.stylix.nixosModules.stylix];

  stylix = {
    enable = true;

    polarity = "dark";

    image = ../../wallpaper/wallpaper.gif;

    base16Scheme = {
      base00 = "#0a0a0f"; # Default Background - Preto espacial profundo
      base01 = "#1a1a2e"; # Lighter Background - Azul escuro do espaço
      base02 = "#2d2d47"; # Selection Background - Azul médio
      base03 = "#4a4a6b"; # Comments, Invisibles - Azul acinzentado
      base04 = "#7a7a9f"; # Dark Foreground - Azul claro
      base05 = "#e8e8f0"; # Default Foreground - Branco suave
      base06 = "#f2f2f8"; # Light Foreground - Branco mais claro
      base07 = "#ffffff"; # Light Background - Branco puro das estrelas
      base08 = "#ff6b6b"; # Red - Vermelho suave para erros
      base09 = "#ffa726"; # Orange - Laranja cósmico
      base0A = "#ffeb3b"; # Yellow - Amarelo estrela
      base0B = "#66bb6a"; # Green - Verde aurora
      base0C = "#26c6da"; # Cyan - Ciano cristalino
      base0D = "#5c6bc0"; # Blue - Azul principal da imagem
      base0E = "#ab47bc"; # Purple - Roxo nebulosa
      base0F = "#8d6e63"; # Brown - Marrom cósmico
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FireCode Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sizes = {
        applications = 11;
        terminal = 14;
        desktop = 10;
        popups = 10;
      };
    };

    
    
    autoEnable = true;
  };
}
