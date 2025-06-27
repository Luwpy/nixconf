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
            luks = {
              name = "luks";
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                  keyFile = "/tmp/secret.key";
                };
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
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
                  mountOptions = [
                    "noatime"
                    "compress=zstd:1"
                    "space_cache=v2"
                  ];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "noatime"
                    "compress=zstd:1"
                    "space_cache=v2"
                  ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "noatime"
                    "compress=zstd:1"
                    "space_cache=v2"
                  ];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "noatime"
                    "compress=zstd:1"
                    "space_cache=v2"
                  ];
                };
                "/var/log" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "noatime"
                    "compress=zstd:1"
                    "space_cache=v2"
                  ];
                };
                "/.snapshots" = {
                  mountpoint = "/.snapshots";
                  mountOptions = [
                    "noatime"
                    "compress=zstd:1"
                    "space_cache=v2"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}