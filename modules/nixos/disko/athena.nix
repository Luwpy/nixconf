{
  lib,
  device ? "ata-S3SSDA480_S3+4802104290073",
  swapSizeInGb,
  ...
}: {
  devices = {
    disk = {
      main = {
        type = "disk";
        inherit device ;
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02";
            };
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            luks = {
              size = "250G";
              content = {
                type = "luks";
                name = "crypted";

                settings = {
                  allowDiscards = true;
                  keyFile = "/tmp/secret.key";
                };
                # additionalKeyFiles = ["/tmp/additionalSecret.key"];
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                      ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                      ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = ["noatime" "compress=zstd"];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
