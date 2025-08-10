{
  inputs,
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  # Basic system configuration that applies to all hosts

  # Set default editor
  environment.variables.EDITOR = lib.mkDefault "nano";

  # Essential system packages
  environment.systemPackages = with pkgs; [
    # Nix tools
    alejandra # Nix formatter
    nil # Nix language server
    nix-output-monitor # Better nix build output

    # System tools
    git
    curl
    wget
    htop
    tree
    file
    unzip
    killall
  ];

  programs.firefox.enable = lib.mkDefault true;

  # Basic networking
  networking.hostName = lib.mkDefault "nixos";

  # Time and locale defaults
  services.automatic-timezoned.enable = true;
  console.keyMap = lib.mkDefault "us";

  # Internationalization
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = lib.mkDefault {};
  };

  # Enable fish shell system-wide
  programs.fish = lib.mkDefault {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      bind -k nul -M insert 'accept-autosuggestion'
    '';
  };

  # SSH server configuration
  services.openssh = lib.mkDefault {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  # Default user configuration
  users = {
    mutableUsers = lib.mkDefault false;
    users.${username} = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
      shell = lib.mkDefault pkgs.fish;
      # hashedPasswordFile = config.sops.secrets.user_password.path;
      initialPassword = "1726832";
      # Note: Set hashedPassword in your host config or use SOPS
    };
  };

  # Sudo configuration
  security.sudo = {
    wheelNeedsPassword = lib.mkDefault false;
    execWheelOnly = lib.mkDefault true;
  };

  # Nixpkgs configuration
  nixpkgs = {
    config.allowUnfree = lib.mkDefault true;
    overlays = [
      # Add unstable packages overlay
      (_final: _prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = pkgs.system;
          config.allowUnfree = true;
        };
      })
    ];
  };

  # Nix daemon configuration
  nix = {
    package = lib.mkDefault pkgs.nixVersions.latest;

    # Automatic garbage collection
    # gc = {
    #   automatic = lib.mkDefault true;
    #   dates = "weekly";
    #   options = "--delete-older-than 7d";
    # };

    settings = {
      # Enable flakes and new nix command
      experimental-features = ["nix-command" "flakes"];

      # Optimize store automatically
      auto-optimise-store = true;

      # Accept flake configs
      accept-flake-config = true;

      # Trusted users
      trusted-users = ["root" "@wheel" username];

      # Binary caches for faster builds
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  # Disable documentation by default (can be overridden)
  documentation = lib.mkDefault {
    enable = false;
    nixos.enable = false;
    man.enable = false;
    dev.enable = false;
  };

  # System state version
  system.stateVersion = lib.mkDefault "25.05";
}
