{
  config,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;

    settings = {
      # theme = "dark_plus";

      editor = {
        line-number = "relative";

        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "bar";
        };

        whitespace.render = {
          space = "none";
          tab = "all";
          newline = "none";
        };

        indent = {
          tab-width = 4;
          unit = "    ";
        };

        # Auto-completion
        completion-trigger-len = 2;
        auto-completion = true;
        auto-format = true;
        auto-save = false;

        statusline = {
          left = ["mode" "spinner"];
          center = ["file-name"];
          right = ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
        };

        # LSP settings
        lsp = {
          display-messages = true;
          auto-signature-help = true;
          display-inlay-hints = true;
        };

        # File picker settings
        file-picker = {
          hidden = false;
          follow-symlinks = true;
          deduplicate-links = true;
          parents = true;
          ignore = true;
          git-ignore = true;
          git-global = true;
          git-exclude = true;
        };

        # Search settings
        search = {
          smart-case = true;
          wrap-around = true;
        };
      };
    };

    languages = {
      language-server = {
        # Rust
        rust-analyzer = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          config = {
            checkOnSave = {
              command = "clippy";
            };
            cargo = {
              features = "all";
            };
          };
        };

        # Python
        pylsp = {
          command = "${pkgs.python3Packages.python-lsp-server}/bin/pylsp";
          config = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  enabled = false;
                };
                mccabe = {
                  enabled = false;
                };
                pyflakes = {
                  enabled = false;
                };
                flake8 = {
                  enabled = true;
                };
                autopep8 = {
                  enabled = false;
                };
                yapf = {
                  enabled = false;
                };
                black = {
                  enabled = true;
                };
              };
            };
          };
        };

        # TypeScript/JavaScript
        typescript-language-server = {
          command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
          args = ["--stdio"];
          config = {
            documentFormatting = false;
          };
        };

        # Go
        gopls = {
          command = "${pkgs.gopls}/bin/gopls";
        };

        nixd = {
          command = "${pkgs.nixd}/bin/nixd";
        };
      };

      language = [
        {
          name = "rust";
          auto-format = true;
          formatter = {
            command = "${pkgs.rustfmt}/bin/rustfmt";
            args = ["--edition" "2021"];
          };
        }
        {
          name = "python";
          auto-format = true;
          formatter = {
            command = "${pkgs.python3Packages.black}/bin/black";
            args = ["-" "--quiet"];
          };
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "${pkgs.alejandra}/bin/alejandra";
          };
        }
        {
          name = "javascript";
          auto-format = true;
          # formatter = {
          #   command = "${pkgs.nodePackages.prettier}/bin/prettier";
          #   args = ["--parser" "typescript"];
          # };
        }
        {
          name = "typescript";
          auto-format = true;
          # formatter = {
          #   command = "${pkgs.nodePackages.prettier}/bin/prettier";
          #   args = ["--parser" "typescript"];
          # };
        }
      ];
    };
  };

  home.packages = with pkgs; [
    rust-analyzer
    gopls
    nixd
    alejandra
    nodePackages.typescript-language-server
    python3Packages.python-lsp-server

    rustfmt

    ripgrep
    fd
    tree-sitter
  ];
}
