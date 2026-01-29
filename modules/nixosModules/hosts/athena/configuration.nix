{
  inputs,
  self,
  config,
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

      # inputs.chaotic.nixosModules.default
    ];

    programs.corectrl.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_zen;

    boot = {
      supportedFilesystems.ntfs = true;
      loader.grub.enable = true;
      loader.grub.efiSupport = true;
      loader.grub.efiInstallAsRemovable = true;
      loader.grub.useOSProber = true;

      kernelParams = ["quiet" "amd_pstate=active"];
      kernelModules = ["coretemp" "cpuid" "v2l4loopback"];
      extraModulePackages = [pkgs.linuxPackages_zen.v4l2loopback];
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
    powerManagement.cpuFreqGovernor = "performance";

    services = {
      hardware.openrgb.enable = true;
      flatpak.enable = true;
      udisks2.enable = true;
    };

    environment.systemPackages = with pkgs; [
      wineWowPackages.stable
      wineWowPackages.waylandFull
      glib

      zerotierone

      vscode

      android-tools

      podman-compose
      podman-tui

      libreoffice-fresh

      warp-terminal
    ];

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    xdg.portal.enable = true;

    hardware.graphics.enable = true;

    networking.firewall.enable = false;
    programs.appimage.enable = true;
    programs.appimage.binfmt = true;
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;

      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        wlrobs
      ];
    };
    programs._1password.enable = true;
    programs._1password-gui.enable = true;

    persistance.data.directories = [
      ".config/1password"
    ];

    services.xserver.videoDrivers = ["amdgpu"];
    boot.initrd.kernelModules = ["amdgpu"];

    security.sudo.wheelNeedsPassword = false;

    system.stateVersion = "25.11";
  };
}
