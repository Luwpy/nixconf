{
  inputs,
  config,
  lib,
  pkgs,
  username,
  ...
}:
let

in
a {
  imports = [
    inputs.nixos-facter.nixosModules.facter
    { config.facter.reportPath = ../../facter.athena.json; }

    ../disko
  ];

  modules.disko = {
    enable = true;
    device = "/dev/disk/by-id/ata-S3SSDA480_S3+4802104290073";
    swapSizeInGb = "16G";
    fileSystem = "athena";
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking = {
    hostName = "athena";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  services = {
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
