{
  inputs,
  self,
  lib,
  ...
}: {
  # flake-parts leaves custom outputs undeclared; with vendored upstream hosts
  # (hosts/main) also defining diskoConfigurations children, sibling leaf
  # definitions need a mergeable type to coexist.
  flake.nixosConfigurations.lalu = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.hostLalu];
  };

  flake.nixosModules.hostLalu = {
    pkgs,
    config,
    ...
  }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.desktop

      self.nixosModules.impermanence

      self.nixosModules.discord

      self.nixosModules.gaming
      self.nixosModules.powersave

      self.nixosModules.virt
      #Disko
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.hostLalu

      # Hermes agent
      self.nixosModules.hermes-agent
    ];

    boot = {
      kernelPackages = pkgs.linuxPackages_latest;

      loader.grub.enable = true;
      loader.grub.efiSupport = true;
      loader.grub.efiInstallAsRemovable = true;

      supportedFilesystems.ntfs = true;

      kernelParams = ["quiet"];
      kernelModules = ["coretemp" "cpuid"];

      binfmt.emulatedSystems = ["aarch64-linux"];
    };

    boot.plymouth.enable = true;

    networking = {
      hostName = "lalu";
      networkmanager.enable = true;
    };

    hardware.cpu.intel.updateMicrocode = true;

    services = {
      flatpak.enable = true;
      udisks2.enable = true;
      printing.enable = true;

      hardware.bolt.enable = true;

      gnome.gnome-keyring.enable = true;
    };

    systemd.services.rfkill-unblock-bluetooth = {
      description = "Unblock bluetooth radio on boot";
      wantedBy = ["bluetooth.target"];
      before = ["bluetooth.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
      };
    };

    environment.systemPackages = with pkgs; [
      winetricks
      glib

      zerotierone

      android-tools

      stremio-linux-shell

      whatsapp-electron
    ];

    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    xdg.portal.enable = true;

    hjem.users.${config.preferences.user.name}.files.".config/xdg-desktop-portal-wlr/config".text = ''
      [screencast]
      chooser_type=dmenu
      choose_cmd=${selfpkgs.vjSharePicker}/bin/vjSharePicker
    '';

    hardware.graphics.enable = true;

    programs._1password.enable = true;
    programs._1password-gui.enable = true;

    persistance.data.directories = [
      ".config/1Password"
      ".local/share/1Password"
      ".config/op"
      ".local/share/hermes-agent"
    ];

    persistance.cache.directories = [
      ".cache/op"
      ".cache/hermes-agent"
    ];

    networking.firewall.enable = false;
    networking.firewall.allowedUDPPorts = [53 67];

    programs.appimage.enable = true;
    programs.appimage.binfmt = true;

    services.xserver.videoDrivers = ["modesetting"];

    system.stateVersion = "26.05";
  };
}
