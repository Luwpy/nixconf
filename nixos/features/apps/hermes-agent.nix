{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hermes-agent = {
    pkgs,
    config,
    ...
  }: {
    imports = [inputs.hermes-agent.nixosModules.default];
    
    persistance.data.directories = [
        ".hermes"
    ];

    security.sudo.extraRules = [
      {
        users = [config.preferences.user.name];
        commands = [
          {
            command = "/run/current-system/sw/bin/podman";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];

    services.hermes-agent = {
      enable = true;
      container.enable = true;
      container.backend = "podman";
      container.image = "docker.io/library/debian:bookworm-slim";
      container.hostUsers = [config.preferences.user.name];

      environmentFiles = ["/persist/nvidia-key" "/persist/hermes-discord"];
      addToSystemPackages = true;
      extraDependencyGroups = ["messaging"];
      extraArgs = ["--verbose"];
      restart = "always";
      restartSec = 5;

      settings = {
        model = {
          provider = "nvidia";
          default = "nvidia/nemotron-3.1-nano-30b-v1";
        };

        providers.nvidia = {
        api = "https://integrate.api.nvidia.com/v1";
          key_env = "NVIDIA_API_KEY";
          transport = "chat_completions";
        };

        toolsets = ["all"];
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
        display = {compact = false;};
        agent = {
          max_turns = 60;
          verbose = false;
        };
      };
    };
  };
}
