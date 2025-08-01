{
  pkgs,
  lib,
  ...
}: {
  vim = {
    theme = {
      name = "onedark";
      style = "dark";
    };

    languages = {
      nix.enable = true;
      lua.enable = true;
      # json.enable = true;
      rust.enable = true;
      ts.enable = true;
    };

    autocomplete.nvim-cmp.enable = true;
    telescope.enable = true;
  };
}
