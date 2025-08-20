{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.amd;
in {
  options.modules.amd = {
    enable = lib.mkEnableOption "AMD GPU support";
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.kernelModules = ["amdgpu"];
    boot.kernelModules = [
      "amd_pstate=guided"
      "amdgpu.si_support=1"
      "amdgpu.cik_support=1"
      "radeon.si_support=0"
      "radeon.cik_support=0"
    ];

    powerManagement.cpuFreqGovernor = "schedutil";

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vulkan-extension-layer
        vulkan-loader
        vulkan-validation-layers
        mesa
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [mesa];
    };
  };
}
