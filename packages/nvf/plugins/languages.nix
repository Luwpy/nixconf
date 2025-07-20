{
  vim = {
    languages = {
      enableFormat = true;
      enableDAP = true;
      enableTreesitter = true;

      bash = {
        enable = true;
        format.enable = true;
        lsp.enable = true;
      };

      lua = {
        enable = true;
        format.enable = true;
        lsp.enable = true;
      };

      nix = {
        enable = true;
        format.enable = true;
        format.type = "alejandra";
        lsp = {
          enable = true;
          server = "nixd";
          options = {
            nixpkgs = {
              expr = "import <nixpkgs> { }";
            };
          };
        };
        extraDiagnostics = {
          enable = true;
          types = [
            "statix"
            "deadnix"
          ];
        };
      };

      

      rust = {
        enable = true;
        crates = {
          enable = true;
          codeActions = true;
        };
        format.enable = true;
        format.type = "rustfmt";
        lsp = {
          enable = true;
          opts = ''
            ['rust-analyzer'] = {
              cargo = {allFeature = true},
              checkOnSave = true;
              procMacro = {
                enable =true;
              },
            },
          '';
        };
      };
    };
  };
}
