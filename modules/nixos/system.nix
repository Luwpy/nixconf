{
  inputs,
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  system.stateVersion = "25.11";

  services.automatic-timezoned.enable = lib.mkDefault true;

  i18n.defaultLocale = "en_US.UTF-8";

  environment.variables.EDITOR = lib.mkDefault "nano";

  environment.systemPackages = with pkgs; [nixd alejandra nix-output-monitor helix];

  console.keyMap = "br-abnt2";

  services.openssh = lib.mkDefault {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users = {
    mutableUsers = lib.mkDefault false;
    users.${username} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      initialPassword = "1726832";
    };
  };

  security.sudo.wheelNeedsPassword = lib.mkDefault false;
  security.sudo.execWheelOnly = lib.mkDefault true;

  nixpkgs = {
    config.allowUnfree = lib.mkForce true;
  };

  nix = {
    package = lib.mkDefault pkgs.nixVersions.latest;
    gc = {
      automatic = lib.mkDefault true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      accept-flake-config = true;
      trusted-users = ["root" "@wheel" "luwpy"];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org/"
        "https://pre-commit-hooks.cachix.org/"
        "https://numtide.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      ];
    };
  };

  documentation = lib.mkDefault {
    enable = false;
    nixos.enable = false;
    man.enable = false;
    dev.enable = false;
  };
}
