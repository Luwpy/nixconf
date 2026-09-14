{self, ...}: {
  flake.wrappers.fastfetch = {
    wlib,
    lib,
    ...
  }: let
    inherit (self) theme;
  in {
    imports = [wlib.wrapperModules.fastfetch];

    settings = {
      logo = {
        type = "builtin";
        source = "nixos_small";
        padding = {
          top = 0;
          right = 2;
        };
        color = {
          "1" = theme.base0D;
          "2" = theme.base08;
          "3" = theme.base05;
          "4" = theme.base0E;
          "5" = theme.base0C;
          "6" = theme.base0A;
        };
      };
      display = {
        separator = ": ";
        color = {
          keys = theme.base0D;
          title = theme.base07;
          separator = theme.base03;
          output = theme.base06;
        };
        key = {
          width = 12;
          type = "string";
        };
        bar = {
          width = 24;
          char = {
            elapsed = "■";
            total = "░";
          };
        };
        percent = {
          type = 9;
          color = {
            green = theme.base0B;
            yellow = theme.base0A;
            red = theme.base08;
          };
        };
      };
      modules = [
        "title"
        "separator"
        {
          type = "os";
          key = "OS";
        }
        {
          type = "kernel";
          key = "Kernel";
        }
        {
          type = "uptime";
          key = "Uptime";
        }
        {
          type = "packages";
          key = "Packages";
        }
        {
          type = "shell";
          key = "Shell";
        }
        {
          type = "terminal";
          key = "Terminal";
        }
        {
          type = "de";
          key = "DE";
        }
        {
          type = "wm";
          key = "WM";
        }
        {
          type = "cpu";
          key = "CPU";
          temp = true;
          showPeCoreCount = true;
        }
        {
          type = "gpu";
          key = "GPU";
          driverSpecific = true;
        }
        {
          type = "memory";
          key = "Memory";
          percent = {
            type = 2;
          };
        }
        {
          type = "disk";
          key = "Disk";
          folders = "/";
        }
        {
          type = "battery";
          key = "Battery";
          temp = true;
        }
        "break"
        "colors"
      ];
    };
  };
}
