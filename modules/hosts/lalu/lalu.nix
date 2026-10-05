{
  inputs,
  self,
  ...
}: {
  hosts.lalu = {pkgs, ...}: {
    imports = [
      self.modules.nixos.base
      self.modules.nixos.desktop
      self.modules.nixos.personal

      self.modules.nixos.impermanence

      self.modules.nixos.gaming
      self.modules.nixos.powersave

      self.modules.nixos.virt

      inputs.disko.nixosModules.disko
      self.diskoConfigurations.lalu
    ];

    preferences.user.name = "luwpy";

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

      obsidian
    ];

    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    xdg.portal.enable = true;

    
    system.stateVersion = "26.05";
  };
}
