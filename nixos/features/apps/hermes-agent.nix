{ self, inputs, ... }:
{
  flake.nixosModules.hermes-agent = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      inputs.hermes-agent.nixosModules.default
    ];

    persistance.data.directories = [
      ".hermes"
    ];

    persistance.cache.directories = [
      ".cache/hermes"
    ];

    # Permite que `hermes` execute podman sem pedir senha.
    # O Hermes detecta automaticamente que precisa de sudo.
    security.sudo.extraRules = [
      {
        users = [ config.preferences.user.name ];
        commands = [
          {
            command = "/run/current-system/sw/bin/podman";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    environment.systemPackages = [
      inputs.cua.packages.${pkgs.stdenv.hostPlatform.system}.cua-driver
    ];

    services.gnome.at-spi2-core.enable = true;

    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface".toolkit-accessibility = true;
      }
    ];

    services.hermes-agent = {
      enable = true;
      createUser = true;

      extraPackages = with pkgs; [
        python3
        pandoc
      ];

      extraPythonPackages = [
        pkgs.python3Packages.youtube-transcript-api
        pkgs.python3Packages.uv
      ];

      # =========================
      # CONTAINER
      # =========================

      container = {
        enable = true;
        backend = "podman";

        image = "docker.io/library/debian:bookworm-slim";

        # Faz o CLI do host compartilhar o estado
        # do Hermes com o container.
        hostUsers = [
          config.preferences.user.name
        ];

        # HOST                              CONTAINER
        # ~/Documents  ------------------>  /home/hermes/Documents
        extraVolumes = [
          "/home/${config.preferences.user.name}/Documents:/home/hermes/Documents:rw"
        ];
      };

      # O Hermes começa nesse diretório.
      workingDirectory = "/home/hermes/Documents";

      environmentFiles = [
        "/persist/nvidia-key"
        "/persist/hermes-discord"
      ];

      environment = {
        CUA_DRIVER_RS_ENABLE_WAYLAND = "1";
      };

      addToSystemPackages = true;

      extraDependencyGroups = [
        "messaging"
        "exa"
      ];

      extraArgs = [
        "--verbose"
      ];

      restart = "always";
      restartSec = 5;

      settings = {
        model = {
          provider = "nvidia";
          default = "nvidia/nemotron-3-nano-omni-30b-a3b-reasoning";
        };

        providers.nvidia = {
          api = "https://integrate.api.nvidia.com/v1";
          key_env = "NVIDIA_API_KEY";
          transport = "chat_completions";
        };

        gateway.enable = true;

        toolsets = [
          "all"
        ];

        max_turns = 100;

        terminal = {
          backend = "local";
          cwd = ".";
          timeout = 180;
        };

        memory = {
          memory_enabled = true;
          user_profile_enabled = true;
        };

        display = {
          compact = false;
        };

        agent = {
          max_turns = 60;
          verbose = false;
        };
      };
    };
  };
}
