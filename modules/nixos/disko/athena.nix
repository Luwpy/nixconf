{
  lib,
  device,
  swapSizeInGb,
  ...
}: {
  devices = {
    disk = {
      main = {
        type = "disk";
        inherit device;
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02"; # BIOS boot partition
            };
            ESP = {
              name = "ESP";
              size = "512M";
              type = "EF00"; # EFI System Partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "root_vg";
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          swap = {
            size = swapSizeInGb;
            content = {
              type = "swap";
              resumeDevice = true; # Enable hibernation
            };
          };
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                };
                "/home" = {
                  mountpoint = "/home";
                };
                "/nix" = {
                  mountpoint = "/nix";
                };
                "/persist" = {
                  mountpoint = "/persist";
                };
                "/var/log" = {
                  mountpoint = "/var/log";
                };
                "/.snapshots" = {
                  mountpoint = "/.snapshots";
                };
              };
            };
          };
        };
      };
    };
  };
}
