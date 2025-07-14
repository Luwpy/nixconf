{pkgs, ...}: {
  programs = {
    zsh = {
      enable = true;


    programs.zsh.initExtra = ''
      eval "$(${cfg.package}/bin/zoxide init zsh ${cfgOptions})"
    '';

    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd"];
    };
  };
}
