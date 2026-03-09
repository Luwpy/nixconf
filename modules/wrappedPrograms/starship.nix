{
  inputs,
  lib,
  self,
  ...
}: let
  inherit (self) theme;
in {
  perSystem = {pkgs, system, ...}: let
    starshipConfig = pkgs.writeText "starship.toml" ''
      # version: 1.0.0
      "$schema" = 'https://starship.rs/config-schema.json'

      add_newline = true
      continuation_prompt = "[▸▹ ](dimmed #${theme.base07})"

      format = """($custom$fill$git_metrics\n)$cmd_duration\
      $jobs\
      $sudo\
      $username\
      $character"""

      right_format = """
      $directory\
      $nix_shell\
      $docker_context\
      $package\
      $c\
      $cpp\
      $golang\
      $nodejs\
      $deno\
      $lua\
      $python\
      $rust\
      $java\
      $julia\
      $status\
      $os"""

      [fill]
      symbol = ' '

      [character]
      format = "$symbol "
      success_symbol = "[◎](bold italic #${theme.base0A})"
      error_symbol = "[○](italic #${theme.base0E})"
      vimcmd_symbol = "[■](italic dimmed #${theme.base0B})"
      vimcmd_replace_one_symbol = "◌"
      vimcmd_replace_symbol = "□"
      vimcmd_visual_symbol = "▼"

      [sudo]
      format = "[$symbol]($style)"
      style = "bold italic #${theme.base0E}"
      symbol = "⋈┈"
      disabled = false

      [username]
      style_user = "bold italic #${theme.base0A}"
      style_root = "bold italic #${theme.base08}"
      format = "[⭘ $user]($style) "
      disabled = false
      show_always = false

      [directory]
      home_symbol = "⌂"
      truncation_length = 2
      truncation_symbol = "□ "
      read_only = " ◈"
      use_os_path_sep = true
      style = "italic #${theme.base0D}"
      format = '[$path]($style)[$read_only]($read_only_style)'
      repo_root_style = "bold #${theme.base0D}"
      repo_root_format = '[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) [△](bold #${theme.base0D})'

      [cmd_duration]
      format = "[◄ $duration ](italic #${theme.base07})"

      [jobs]
      format = "[$symbol$number]($style) "
      style = "#${theme.base07}"
      symbol = "[▶](italic #${theme.base0D})"

      # ── Git modules desabilitados — jj-starship cuida de tudo ──────────────

      [git_branch]
      disabled = true

      [git_status]
      disabled = true

      [git_metrics]
      disabled = true

      [git_commit]
      disabled = true

      [git_state]
      disabled = true

      # ── jj-starship: suporte unificado para jj e git ────────────────────────

      [custom.jj]
      command = "jj-starship"
      when = "jj-starship detect"
      format = "[ $output]($style) "
      style = "bold italic #${theme.base0E}"
      symbol = ""

      # ── Linguagens ──────────────────────────────────────────────────────────

      [deno]
      format = " [deno](italic) [∫ $version](#${theme.base0B} bold)"
      version_format = "''${raw}"

      [lua]
      format = " [lua](italic) [''${symbol}''${version}]($style)"
      version_format = "''${raw}"
      symbol = "⨀ "
      style = "bold #${theme.base0A}"

      [nodejs]
      format = " [node](italic) [◫ ($version)](bold #${theme.base0B})"
      version_format = "''${raw}"
      detect_files = ["package-lock.json", "yarn.lock"]
      detect_folders = ["node_modules"]
      detect_extensions = []

      [python]
      format = " [py](italic) [''${symbol}''${version}]($style)"
      symbol = "[⌉](bold #${theme.base0D})⌊ "
      version_format = "''${raw}"
      style = "bold #${theme.base0A}"

      [rust]
      format = " [rs](italic) [$symbol$version]($style)"
      symbol = "⊃ "
      version_format = "''${raw}"
      style = "bold #${theme.base08}"

      [package]
      format = " [pkg](italic dimmed) [$symbol$version]($style)"
      version_format = "''${raw}"
      symbol = "◨ "
      style = "dimmed italic bold #${theme.base0A}"

      [golang]
      symbol = "∩ "
      format = " go [$symbol($version )]($style)"

      [java]
      symbol = "∪ "
      format = " java [''${symbol}(''${version} )]($style)"

      [julia]
      symbol = "◎ "
      format = " jl [$symbol($version )]($style)"

      [c]
      symbol = "ℂ "
      format = " [$symbol($version(-$name))]($style)"

      [cpp]
      symbol = "ℂ "
      format = " [$symbol($version(-$name))]($style)"

      [docker_context]
      symbol = "◧ "
      format = " docker [$symbol$context]($style)"

      [nix_shell]
      style = "bold italic dimmed #${theme.base0D}"
      symbol = '✶'
      format = '[$symbol nix⎪$state⎪]($style) [$name](italic dimmed #${theme.base07})'
      impure_msg = "[⌽](bold dimmed #${theme.base08})"
      pure_msg = "[⌾](bold dimmed #${theme.base0B})"
      unknown_msg = "[◌](bold dimmed #${theme.base0A})"
    '';
  in {
    packages.starship = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.starship;
      runtimeInputs = [
      inputs.jj-starship.packages.${system}.default
      ];
      env = {
        STARSHIP_CONFIG = starshipConfig;
      };
    };
  };
}
