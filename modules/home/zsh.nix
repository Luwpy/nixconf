{pkgs, ...}: {
  programs = {
    zsh = {
      enable = true;

      initContent = ''
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh --cmd cd)"
      '';
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      # options = [ "--cmd cd"];
    };

    helix = {
      enable = true;
      # settings = {
      #   theme = "tokyonight";
      # };

      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "pkgs.alejandra/bin/alejandra";
        }
      ];
    };
  };
}
