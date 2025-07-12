{inputs, ...}: {
  imports = [inputs.niri-flake.nixosModules.niri];

  programs.niri.enable = true;
}
