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

  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = ["@wheel" "${username}"];

  modules = {
    ############# HOME #############
    home = {
      enable = true;

      modules =
        [
        ]
        ++ homeSystemModules ++ homePrograms;
    };
    ############# MODULES #############
    sops = {
      enable = true;

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
      image = ../../wallpaper/wallpaper.png;
      polarity = "dark";

      cursor = {
        name = "phinger-cursors-light";
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
      enable = true;
      steam.enable = true;
    };
  };
}
