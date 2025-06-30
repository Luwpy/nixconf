{
  inputs,
  config,
  lib,
  username,
  ...
}: {
  imports = [inputs.nixos-wsl.nixosModules.wsl];

  config = lib.mkIf config.wsl.enable {
    wsl = {
      wslConf.automount.root = "/mnt";
      wslConf.user.default = username;
      defaultUser = username;
      startMenuLaunchers = true;
      interop.register = true;
      useWindowsDriver = true;
    };
  };
}