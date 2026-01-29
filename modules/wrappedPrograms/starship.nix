{
  inputs,
  lib,
  self,
  ...
}: let
  inherit (self) theme;
in {
  perSystem = {pkgs, ...}: let
    starshipConfig = pkgs.writeText "starship.toml" ''
      command_timeout = 1000

      format = """
      [╭─](bold ${theme.base09})\
      $username\
      $hostname\
      $directory\
      $git_branch\
      $git_status\
      $git_state\
      $nix_shell\
      $rust\
      $nodejs\
      $python\
      $lua\
      $cmd_duration
      [╰─](bold ${theme.base09})$character"""

      [character]
      success_symbol = "[➜](bold ${theme.base0B})"
      error_symbol = "[➜](bold ${theme.base08})"
      vimcmd_symbol = "[❮](bold ${theme.base0E})"

      [username]
      style_user = "bold ${theme.base0A}"
      style_root = "bold ${theme.base08}"
      format = "[$user]($style) "
      disabled = false
      show_always = true

      [hostname]
      ssh_only = false
      format = "[@$hostname](bold ${theme.base0D}) "
      disabled = false

      [directory]
      truncation_length = 3
      truncate_to_repo = true
      format = "[$path]($style)[$read_only]($read_only_style) "
      style = "bold ${theme.base0C}"
      read_only = " 󰌾"
      read_only_style = "${theme.base08}"

      [directory.substitutions]
      "Documents" = "󰈙 "
      "Downloads" = " "
      "Music" = " "
      "Pictures" = " "
      "Projects" = " "
      "Videos" = " "
      ".config" = " "
      "nixconf" = " "

      [git_branch]
      symbol = " "
      format = "[$symbol$branch(:$remote_branch)]($style) "
      style = "bold ${theme.base0E}"

      [git_status]
      format = "([$all_status$ahead_behind]($style) )"
      style = "bold ${theme.base08}"
      conflicted = "="
      ahead = "⇡''${count}"
      behind = "⇣''${count}"
      diverged = "⇕⇡''${ahead_count}⇣''${behind_count}"
      untracked = "?''${count}"
      stashed = "$"
      modified = "!''${count}"
      staged = "+''${count}"
      renamed = "»''${count}"
      deleted = "✘''${count}"

      [git_state]
      format = "[$state( $progress_current/$progress_total)]($style) "
      style = "bold ${theme.base0A}"

      [cmd_duration]
      min_time = 500
      format = "[took $duration]($style) "
      style = "bold ${theme.base03}"

      [nix_shell]
      symbol = " "
      format = "[$symbol$state( \\($name\\))]($style) "
      style = "bold ${theme.base0D}"
      impure_msg = "[impure](bold ${theme.base08})"
      pure_msg = "[pure](bold ${theme.base0B})"

      [rust]
      symbol = " "
      format = "[$symbol($version)]($style) "
      style = "bold ${theme.base08}"

      [nodejs]
      symbol = " "
      format = "[$symbol($version)]($style) "
      style = "bold ${theme.base0B}"

      [python]
      symbol = " "
      format = "[$symbol($version)(\\($virtualenv\\))]($style) "
      style = "bold ${theme.base0A}"

      [lua]
      symbol = " "
      format = "[$symbol($version)]($style) "
      style = "bold ${theme.base0D}"

      [package]
      symbol = "󰏗 "
      format = "[$symbol$version]($style) "
      style = "bold ${theme.base0A}"

      [battery]
      full_symbol = "󰁹 "
      charging_symbol = "󰂄 "
      discharging_symbol = "󰂃 "

      [[battery.display]]
      threshold = 10
      style = "bold ${theme.base08}"
    '';
  in {
    packages.starship = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.starship;
      env = {
        STARSHIP_CONFIG = starshipConfig;
      };
    };
  };
}
