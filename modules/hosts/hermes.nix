{
  inputs,
  lib,
  pkgs,
  username,
  ...
}: {
  #  _modules.args.username = "luwpy";

  imports = [
    inputs.nixos-wsl.nixosModules.wsl

    ../home
    ../nixos/sops.nix
    ../nixos/system.nix
    ../nixos/wsl.nix
  ];

  environment = {
    systemPackages = with pkgs; [usbutils coreutils];
    variables = {
      NIX_LD_LIBRARY_PATH = lib.mkForce (lib.makeLibraryPath [
        "/run/current-system/sw/share/nix-ld"
        "/usr/lib/wsl"
      ]);
      LD_LIBRARY_PATH = lib.makeLibraryPath [
        "/usr/lib/wsl"
      ];
    };
  };

  modules.sops.enable = true;

  modules.home = {
    enable = true;
    modules = [
      ../home/git.nix
      ../home/fish.nix
    ];
    packages = with pkgs; [obsidian];
  };

  networking = {
    hostName = "hermes";
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
      trustedInterfaces = ["cni0" "eth0"];
    };
  };

  programs = {
    nix-ld.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d";
    };
  };

  wsl = {
    enable = true;
    usbip = {
      enable = true;
      autoAttach = ["2-7" "2-8"];
    };
  };

  nix.gc.automatic = false;

  documentation = {
    enable = true;
    nixos.enable = true;
    man.enable = true;
    dev.enable = true;
  };
}
