{
  pkgs,
  lib,
  username,
  ...
}: {
  # home.packages = with pkgs; [lazygit];

  programs.git = {
    enable = true;
    userName = "luwpy";
    userEmail = "jpcastro.sp@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = "false";
      push.autoSetupRemote = true;
      color.ui = "1";
    };
  };

  programs.lazygit.enable = true;
}
