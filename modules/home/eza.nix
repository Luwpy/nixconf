{
  programs = {
    eza = {
      enable = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--no-quotes"
        "--all"
        "--icons=always"
        "--show-symlinks"
      ];
    };
    bat = {
      enable = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd cd"]; # This makes zoxide replace the cd command
    };
    helix = {
      enable = true;
      settings = {
        # theme = "tokyonight";

        editor = {
          line-number = "relative";
          mouse = true;
          completion-trigger-len = 2;
          auto-completion = true;
          auto-format = true;
          auto-save = true;
          bufferline = "multiple";
          color-modes = true;
          cursorline = true;
          gutters = [
            "diagnostics"
            "spacer"
            "line-numbers"
            "spacer"
            "diff"
          ];
          indent-guides = {
            render = true;
            character = "┊";
            skip-levels = 1;
          };
          soft-wrap.enable = true;
          statusline = {
            left = [
              "mode"
              "spacer"
              "spinner"
              "file-name"
              "file-modification-indicator"
            ];
            center = [];
            right = [
              "diagnostics"
              "selections"
              "register"
              "position"
              "file-encoding"
            ];
            separator = "│";
            mode.normal = "NORMAL";
            mode.insert = "INSERT";
            mode.select = "SELECT";
          };
        };

        keys.normal = {
          space.space = "file_picker";
          space.w = ":w";
          space.q = ":q";
          space.f = "file_picker_in_current_directory";
          space.b = "buffer_picker";
          space.e = ":open .";
          C-s = ":w";
          ";" = "command_mode";
        };
      };

      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "alejandra";
        }
      ];

      languages.language-server.nixd = {
        command = "nixd";
        config.nixd = {
          formatting.command = ["alejandra"];
          options = {
            nixos.expr = "(builtins.getFlake \"/persist/nixconf\").nixosConfigurations.athena.options";
            home-manager.expr = "(builtins.getFlake \"/persist/nixconf\").homeConfigurations.\"luwpy@athena\".options";
          };
        };
      };
    };
  };
}
