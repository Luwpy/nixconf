{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.hermes = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.hostHermes
    ];
  };

  flake.nixosModules.hostHermes = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      inputs.nixos-wsl.nixosModules.default
      self.nixosModules.general
      self.nixosModules.base
    ];

    networking.hostName = "hermes";

    services.automatic-timezoned.enable = true;
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };

    wsl.enable = true;
    wsl.defaultUser = config.preferences.user.name;
    wsl.docker-desktop.enable = true;

    virtualisation.libvirtd.enable = true;
    virtualisation.docker = {
      enable = true;
    };
    environment.systemPackages = with pkgs; [
      wget
    ];

    system.stateVersion = "25.05";
  };
}
