{
  inputs,
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.modules.sops;
in {
  imports = [inputs.sops-nix.nixosModules.sops];
  options.modules.sops = {
    enable = lib.mkEnableOption "sops module";

    defaultSopsFile = lib.mkOption {
      type = lib.types.path;
      default = ../../secrets/default.yaml;
      description = "The default SOPS file used for encryption/decryption.";
    };

    age = {
      keyFile = lib.mkOption {
        type = lib.types.str;
        default = "/home/${username}/.config/sops/age/keys.txt";
        description = "Path to the Age key file.";
      };

      sshKeyPaths = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = ["/etc/ssh/ssh_host_ed25519_key"];
        description = "List of SSH key paths for Age integration.";
      };

      generateKey = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Generate an Age key automatically if missing.";
      };
    };

    secrets = lib.mkOption {
      type = lib.types.attrs;
      default = {
        user_password.neededForUsers = true;
        k3s_token = {};
      };
      description = "An attribute set mapping secret names to their configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [sops age];
    sops = {
      defaultSopsFile = cfg.defaultSopsFile;

      age = {
        keyFile = cfg.age.keyFile;
        sshKeyPaths = cfg.age.sshKeyPaths;
        generateKey = cfg.age.generateKey;
      };

      secrets = cfg.secrets;
    };
  };
}
