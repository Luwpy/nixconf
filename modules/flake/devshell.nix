{inputs, ...}: {
  imports = [inputs.devshell.flakeModule];

  perSystem = {pkgs, ...}: {
    devshells.default = {
      # Development packages available in the shell
      packages = with pkgs; [
        # Nix tools
        helix # Terminal editor
        
        nil # Nix language server
        alejandra # Nix formatter
        deadnix # Find dead Nix code

        # System tools
        git
        curl
        jq # JSON processor

        # Optional deployment tools
        # deploy-rs           # Remote deployment
        # sops                # Secrets management
        # age                 # Encryption
      ];

      # Environment variables
      env = [
        {
          name = "NIX_CONFIG";
          value = "experimental-features = nix-command flakes";
        }
      ];

      # Custom commands available in the shell
      commands = [
        {
          name = "fmt";
          help = "Format all Nix files";
          command = "nix fmt";
          category = "formatters";
        }
        {
          name = "check";
          help = "Check flake for issues";
          command = "nix flake check";
          category = "validation";
        }
        {
          name = "update";
          help = "Update flake inputs";
          command = "nix flake update";
          category = "maintenance";
        }
      ];
    };
  };
}
