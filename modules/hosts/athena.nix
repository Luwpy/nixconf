{
  inputs,
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (inputs.self.lib) importModulesRecursive;

  # Get all module paths from ../nixos directory
  nixosModules = importModulesRecursive ../nixos;
  homeSystemModules = importModulesRecursive ../home/system;
  homePrograms = importModulesRecursive ../home/programs;
  homeScripts = importModulesRecursive ../home/scripts;
in {
  imports =
    nixosModules
    ++ [
      inputs.nixos-facter.nixosModules.facter
      {config.facter.reportPath = ../../facter.athena.json;}

      ../disko
      ../home
    ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  modules.disko = {
    enable = true;
    device = "/dev/disk/by-id/ata-S3SSDA480_S3+4802104290073";
    swapSizeInGb = "16G";
    fileSystem = "athena";
  };

  networking = {
    hostName = "athena";
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
  };

  services = {
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  users.users.${username} = {
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.nh = {
    enable = true;
    flake = "/persist/nixconf";
    clean.enable = true;
    clean.extraArgs = "--keep 5 --keep-since 7d";
  };
  nix.gc.automatic = false;

  programs.firefox.enable = true;
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = ["@wheel" "${username}"];

  environment.systemPackages = [pkgs.openssl];

  modules = {
    ############# HOME #############
    home = {
      enable = true;

      modules =
        [
        ]
        ++ homeSystemModules ++ homePrograms ++ homeScripts;

      packages = with pkgs; [
        vlc
        blanket
        obsidian
        planify
        gnome-calendar
        textpieces
        curtail
        resources
        gnome-clocks
        gnome-text-editor
        mpv

        zip
        unzip
        optipng
        jpegoptim
        pfetch
        btop
        fastfetch

        peaclock
        cbonsai
        pipes
        cmatrix

        vscode
        zed-editor
        bruno
        bruno-cli

        inputs.self.packages.x86_64-linux.neovim
      ];
    };
    ############# MODULES #############
    sops = {
      enable = false;

      age = {
        keyFile = "/persist/age/key.txt";
      };

      secrets = {
        athena_password.neededForUsers = true;
      };
    };

    stylix = {
      enable = true;
      autoEnable = true;
      image = ../../wallpaper/castle.png;
      polarity = "dark";

      cursor = {
        name = "phinger-cursors-dark";
        package = pkgs.phinger-cursors;
        size = 20;
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrains Mono Nerd Font";
        };

        sansSerif = {
          package = pkgs.source-sans-pro;
          name = "Source Sans Pro";
        };
        serif = config.stylix.fonts.sansSerif;
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 13;
          desktop = 13;
          popups = 13;
          terminal = 13;
        };
      };
    };
    sddm.enable = true;

    gaming = {
      enable = false;
    };

    virtualisation = {
      enable = true;

      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket = true;
        extraPackages = with pkgs; [
          podman-tui
          podman-compose
          podman-desktop
        ];
      };

      libvirt = {
        enable = true;
        qemu = true;
      };

      networking = {
        enable = true;
        slirp4netns = true;
      };
    };
  };
}
