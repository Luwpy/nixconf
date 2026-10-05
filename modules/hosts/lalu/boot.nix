{
  hosts.lalu = {pkgs, ...}: {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;

      loader.grub.enable = true;
      loader.grub.efiSupport = true;
      loader.grub.efiInstallAsRemovable = true;

      supportedFilesystems.ntfs = true;

      kernelParams = ["quiet"];
      kernelModules = ["coretemp" "cpuid"];

      binfmt.emulatedSystems = ["aarch64-linux"];

      plymouth.enable = true;
    };

    programs.appimage.enable = true;
    programs.appimage.binfmt = true;
  };
}
