{ pkgs, lib, username, ... }: {
  home.packages = with pkgs; [lazygit];

  programs.git = {
    enable = true;
    userName = "luwpy";
    userEmail = "jpcastro.sp@gmail.com"
  };
}