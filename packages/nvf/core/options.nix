{...}: {
  vim = {
    globals = {
      mapleader = " ";
    };

    options = {
      number = true;
      relativenumber = true;

      tabstop = 2;
      softtabstop = 2;
      showtabline = 2;
      expandtab = true;

      smartindent = true;
      shiftwidth = 2;
      breakindent = true;

      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;

      shada = "!,'100,<50,s10,h";

      wrap = false;
    };
  };
}
