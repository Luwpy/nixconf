{
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        cat = "bat -p";
        find = "fd";
        gc = "nix store gc";
      };
    };
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        nix_shell = {
          symbol = " ";
          format = "$symbol ";
        };
        hostname.format = "$hostname:";
        username.format = "$user@";
      };
    };

    bat.enable = true;
    lsd.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
    fzf = {
      enable = true;
      #      fileWidgetOption = ["--preview 'bat --color=always {}'"];
    };
  };
}
