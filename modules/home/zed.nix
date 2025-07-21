{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "rust"
      "lua"
      "bash"
      "toml"
      "dockerfile"
      "git-firefly"
      "catppuccin"
      "tokyo-night"
    ];

    userSettings = {
      # Appearance
      # theme = {
      #   mode = "dark";
      #   light = "One Light";
      #   dark = "Tokyo Night";
      # };

      #ui_font_size = 16;
      # buffer_font_size = 14;

      # buffer_font_family = "FiraCode Nerd Font";
      # ui_font_family = "FiraCode Nerd Font";

      # Editor behavior
      vim_mode = false;
      relative_line_numbers = true;
      show_whitespaces = "selection";
      show_wrap_guides = true;
      wrap_guides = [
        80
        120
      ];

      cursor_blink = true;
      hover_popover_enabled = true;
      confirm_quit = true;

      # Indentation
      tab_size = 2;
      hard_tabs = false;
      indent_guides = {
        enabled = true;
        line_width = 1;
        active_line_width = 2;
        coloring = "indent_aware";
      };

      # File tree
      project_panel = {
        button = true;
        default_width = 300;
        dock = "left";
        file_icons = true;
        folder_icons = true;
        git_status = true;
        indent_size = 20;
        auto_fold_dirs = false;
        auto_reveal_entries = true;
      };

      # Outline panel
      outline_panel = {
        button = true;
        default_width = 300;
        dock = "right";
        file_icons = true;
        folder_icons = true;
        indent_size = 20;
      };

      # Terminal
      terminal = {
        alternate_scroll = "off";
        blinking = "terminal_controlled";
        copy_on_select = false;
        dock = "bottom";
        default_width = 640;
        default_height = 320;
        # font_family = "FiraCode Nerd Font";
        # font_size = 14;
        option_as_meta = false;
        button = true;
        shell = {
          program = "zsh";
        };
        toolbar = {
          title = true;
        };
        working_directory = "current_project_directory";
      };

      # Auto-save and formatting
      autosave = "on_focus_change";
      format_on_save = "on";
      code_actions_on_format = {
        source.organizeImports = true;
        source.fixAll = true;
      };

      # Collaboration
      collaboration_panel = {
        button = false;
        dock = "left";
        default_width = 240;
      };

      # Chat panel
      chat_panel = {
        button = false;
        dock = "right";
        default_width = 240;
      };

      # Notification panel
      notification_panel = {
        button = true;
        dock = "bottom";
        default_width = 380;
      };

      # Assistant
      assistant = {
        enabled = true;
        button = true;
        dock = "right";
        default_width = 400;
        version = "2";
      };

      # Language settings
      languages = {
        Nix = {
          language_servers = ["nixd"];
          format_on_save = "on";
          formatter = {
            external = {
              command = "alejandra";
              arguments = [];
            };
          };
          tab_size = 2;
        };

        Rust = {
          language_servers = ["rust-analyzer"];
          format_on_save = "on";
          tab_size = 4;
        };

        Lua = {
          language_servers = ["lua-language-server"];
          format_on_save = "on";
          tab_size = 2;
        };

        Bash = {
          language_servers = ["bash-language-server"];
          format_on_save = "on";
          tab_size = 2;
        };

        TOML = {
          format_on_save = "on";
          tab_size = 2;
        };

        JSON = {
          format_on_save = "on";
          tab_size = 2;
        };

        YAML = {
          format_on_save = "on";
          tab_size = 2;
        };

        Markdown = {
          format_on_save = "on";
          tab_size = 2;
          soft_wrap = "editor_width";
        };
      };

      # LSP settings
      lsp = {
        rust-analyzer = {
          binary = {
            path = "rust-analyzer";
          };
          initialization_options = {
            cargo = {
              allFeatures = true;
              loadOutDirsFromCheck = true;
            };
            procMacro = {
              enable = true;
            };
            checkOnSave = {
              command = "clippy";
            };
          };
        };

        nixd = {
          binary = {
            path = "nixd";
          };
          initialization_options = {
            nixd = {
              formatting = {
                command = ["alejandra"];
              };
              options = {
                nixos = {
                  expr = "(builtins.getFlake \"/persist/nixconf\").nixosConfigurations.athena.options";
                };
                home_manager = {
                  expr = "(builtins.getFlake \"/persist/nixconf\").homeConfigurations.\"luwpy@athena\".options";
                };
              };
            };
          };
        };
      };

      # File associations
      file_types = {
        Dockerfile = [
          "Dockerfile"
          "*.dockerfile"
        ];
        JSON = [
          "*.json"
          "*.jsonc"
        ];
        TOML = ["*.toml"];
        YAML = [
          "*.yaml"
          "*.yml"
        ];
        Nix = ["*.nix"];
        Rust = ["*.rs"];
        Lua = ["*.lua"];
        Bash = [
          "*.sh"
          "*.bash"
          "*.zsh"
        ];
      };

      # Git integration
      git = {
        enabled = true;
        git_gutter = "tracked_files";
        inline_blame = {
          enabled = true;
          delay_ms = 600;
        };
      };

      # Search settings
      search = {
        whole_word = false;
        case_sensitive = false;
        include_ignored = false;
        regex = false;
      };

      # Scrollbar
      scrollbar = {
        show = "false";
        git_diff = true;
        search_results = true;
        selected_symbol = true;
        diagnostics = true;
      };

      # Multi-buffer settings
      multi_buffer = {
        warn_on_pin = true;
      };

      # Toolbar settings
      toolbar = {
        breadcrumbs = true;
        quick_actions = true;
      };

      # Tab bar
      tab_bar = {
        show = true;
        show_nav_history_buttons = true;
      };

      # Preview tabs
      preview_tabs = {
        enabled = true;
        enable_preview_from_file_finder = true;
        enable_preview_from_code_navigation = true;
      };

      # Copilot (if you have it)
      features = {
        copilot = false; # Set to true if you have GitHub Copilot
      };

      # Telemetry
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
    };

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "ctrl-shift-e" = "workspace::ToggleLeftDock";
          "ctrl-shift-t" = "workspace::NewTerminal";
          "ctrl-`" = "terminal_panel::ToggleFocus";
          "ctrl-shift-f" = "project_search::ToggleFocus";
          "ctrl-shift-r" = "outline::Toggle";
        };
      }
      {
        context = "ProjectPanel";
        bindings = {
          "a" = "project_panel::NewFile";
          "A" = "project_panel::NewDirectory";
          "r" = "project_panel::Rename";
          "d" = "project_panel::Delete";
          "x" = "project_panel::Cut";
          "c" = "project_panel::Copy";
          "p" = "project_panel::Paste";
        };
      }
    ];
  };
}
