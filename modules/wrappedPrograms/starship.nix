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

      format = """($custom$container$fill$git_metrics\n)$cmd_duration\
      $hostname\
      $localip\
      $shlvl\
      $shell\
      $env_var\
      $jobs\
      $sudo\
      $username\
      $character"""

      right_format = """
      $singularity\
      $kubernetes\
      $directory\
      $vcsh\
      $fossil_branch\
      $pijul_channel\
      $docker_context\
      $package\
      $c\
      $cpp\
      $cmake\
      $cobol\
      $daml\
      $dart\
      $deno\
      $dotnet\
      $elixir\
      $elm\
      $erlang\
      $fennel\
      $fortran\
      $golang\
      $guix_shell\
      $haskell\
      $haxe\
      $helm\
      $java\
      $julia\
      $kotlin\
      $gradle\
      $lua\
      $nim\
      $nodejs\
      $ocaml\
      $opa\
      $perl\
      $php\
      $pulumi\
      $purescript\
      $python\
      $raku\
      $rlang\
      $red\
      $ruby\
      $rust\
      $scala\
      $solidity\
      $swift\
      $terraform\
      $vlang\
      $vagrant\
      $xmake\
      $zig\
      $buf\
      $conda\
      $pixi\
      $meson\
      $spack\
      $memory_usage\
      $aws\
      $gcloud\
      $openstack\
      $azure\
      $crystal\
      $custom\
      $status\
      $os\
      $battery\
      $time"""

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

      [env_var.VIMSHELL]
      format = "[$env_value]($style)"
      style = "italic #${theme.base0B}"

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

      [localip]
      ssh_only = true
      format = " ◯[$localipv4](bold #${theme.base0E})"
      disabled = false

      [time]
      disabled = false
      format = "[ $time]($style)"
      time_format = "%R"
      utc_time_offset = "local"
      style = "italic dimmed #${theme.base07}"

      [battery]
      format = "[ $percentage $symbol]($style)"
      full_symbol = "█"
      charging_symbol = "[↑](italic bold #${theme.base0B})"
      discharging_symbol = "↓"
      unknown_symbol = "░"
      empty_symbol = "▃"

      [[battery.display]]
      threshold = 20
      style = "italic bold #${theme.base08}"

      [[battery.display]]
      threshold = 60
      style = "italic dimmed #${theme.base0E}"

      [[battery.display]]
      threshold = 70
      style = "italic dimmed #${theme.base0A}"

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

      [ruby]
      format = " [rb](italic) [''${symbol}''${version}]($style)"
      symbol = "◆ "
      version_format = "''${raw}"
      style = "bold #${theme.base08}"

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

      [swift]
      format = " [sw](italic) [''${symbol}''${version}]($style)"
      symbol = "◁ "
      style = "bold #${theme.base08}"
      version_format = "''${raw}"

      [aws]
      disabled = true
      format = " [aws](italic) [$symbol $profile $region]($style)"
      style = "bold #${theme.base0D}"
      symbol = "▲ "

      [buf]
      symbol = "■ "
      format = " [buf](italic) [$symbol $version $buf_version]($style)"

      [c]
      symbol = "ℂ "
      format = " [$symbol($version(-$name))]($style)"

      [cpp]
      symbol = "ℂ "
      format = " [$symbol($version(-$name))]($style)"

      [conda]
      symbol = "◯ "
      format = " conda [$symbol$environment]($style)"

      [pixi]
      symbol = "■ "
      format = " pixi [$symbol$version ($environment )]($style)"

      [dart]
      symbol = "◁◅ "
      format = " dart [$symbol($version )]($style)"

      [docker_context]
      symbol = "◧ "
      format = " docker [$symbol$context]($style)"

      [elixir]
      symbol = "△ "
      format = " exs [$symbol $version OTP $otp_version ]($style)"

      [elm]
      symbol = "◩ "
      format = " elm [$symbol($version )]($style)"

      [golang]
      symbol = "∩ "
      format = " go [$symbol($version )]($style)"

      [haskell]
      symbol = "❯λ "
      format = " hs [$symbol($version )]($style)"

      [java]
      symbol = "∪ "
      format = " java [''${symbol}(''${version} )]($style)"

      [julia]
      symbol = "◎ "
      format = " jl [$symbol($version )]($style)"

      [memory_usage]
      symbol = "▪▫▪ "
      format = " mem [''${ram}( ''${swap})]($style)"

      [nim]
      symbol = "▴▲▴ "
      format = " nim [$symbol($version )]($style)"

      [nix_shell]
      style = "bold italic dimmed #${theme.base0D}"
      symbol = '✶'
      format = '[$symbol nix⎪$state⎪]($style) [$name](italic dimmed #${theme.base07})'
      impure_msg = "[⌽](bold dimmed #${theme.base08})"
      pure_msg = "[⌾](bold dimmed #${theme.base0B})"
      unknown_msg = "[◌](bold dimmed #${theme.base0A})"

      [spack]
      symbol = "◇ "
      format = " spack [$symbol$environment]($style)"
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
