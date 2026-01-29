{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.athena = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostAthena
    ];
  };

  flake.nixosModules.hostAthena = {pkgs, ...}: {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.desktop

      self.nixosModules.impermanence

      self.nixosModules.discord
      self.nixosModules.mango
      self.nixosModules.youtube-music

      self.nixosModules.gaming

      inputs.disko.nixosModules.disko
      self.diskoConfigurations.hostAthena
    ];

    programs.corectrl.enable = true;

    boot = {
      loader.grub.enable = true;
      loader.grub.efiSupport = true;
      loader.grub.efiInstallAsRemovable = true;

      supportedFilesystems.nts = true;

      kernelParams = ["quiet"];
      kernelModules = ["coretemp" "cpuid" "v4l2loopback"];
    };

    boot.plymouth.enable = true;

    networking = {
      hostName = "athena";
      networkmanager.enable = true;
    };

    virtualisation.libvirtd.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {dns_enabled = true;};
    };

    hardware.cpu.amd.updateMicrocode = true;

    services = {
      hardware.openrgb.enable = true;
      flatpak.enable = true;
      udisks2.enable = true;
    };

    programs.adb.enable = true;

    environment.systemPackages = with pkgs; [
      wineWowPackages.stable
      wineWowPackages.waylandFull
      glib

      zerotierone
    ];

    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    xdg.portal.enable = true;

    hardware.graphics.enable = true;

    networking.firewall.enable = false;
    programs.appimage.enable = true;
    programs.appimage.binfmt = true;

    programs._1password.enable = true;
    programs._1password-gui.enable = true;

    persistance.cache.directories = [
      ".config/1password"
    ];

    services.xserver.videoDrivers = ["amdgpu"];
    boot.initrd.kernelModules = ["amdgpu"];
    
    security.sudo.wheelNeedsPassword = false;

    system.stateVersion = "25.11";
  };
}
