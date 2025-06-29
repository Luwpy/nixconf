{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.modules.virtualisation;
in {
  options.modules.virtualisation = {
    enable = lib.mkEnableOption "virtualisation module";

    podman = {
      enable = lib.mkEnableOption "Podman container runtime" // {default = true;};
      
      dockerCompat = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Docker compatibility layer for Podman";
      };

      dockerSocket = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Docker socket for compatibility with Docker tools";
      };

      defaultNetwork = lib.mkOption {
        type = lib.types.str;
        default = "podman";
        description = "Default network backend for Podman";
      };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = with pkgs; [
          podman-compose
          buildah
          skopeo
          podman-tui
        ];
        description = "Additional packages to install with Podman";
      };
    };

    docker = {
      enable = lib.mkEnableOption "Docker container runtime";
      
      rootless = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable rootless Docker (conflicts with Podman)";
      };
    };

    libvirt = {
      enable = lib.mkEnableOption "libvirt virtualization";
      
      qemu = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable QEMU support for libvirt";
      };
    };

    waydroid = {
      enable = lib.mkEnableOption "Waydroid Android container";
    };

    networking = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable container networking features";
      };

      slirp4netns = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable slirp4netns for rootless networking";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.podman.enable && cfg.docker.enable);
        message = "Cannot enable both Podman and Docker simultaneously. Choose one container runtime.";
      }
    ];

    # ==================== PODMAN CONFIGURATION ====================
    virtualisation.podman = lib.mkIf cfg.podman.enable {
      enable = true;
      
      # Docker compatibility
      dockerCompat = cfg.podman.dockerCompat;
      dockerSocket.enable = cfg.podman.dockerSocket;
      
      # Default network backend
      defaultNetwork.settings.dns_enabled = true;
      
      # Auto-update containers
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = ["--all"];
      };

      # Extra packages
      extraPackages = cfg.podman.extraPackages;
    };

    # ==================== DOCKER CONFIGURATION ====================
    virtualisation.docker = lib.mkIf cfg.docker.enable {
      enable = true;
      rootless = lib.mkIf cfg.docker.rootless {
        enable = true;
        setSocketVariable = true;
      };
      
      # Auto-prune
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = ["--all"];
      };
    };

    # ==================== LIBVIRT CONFIGURATION ====================
    virtualisation.libvirtd = lib.mkIf cfg.libvirt.enable {
      enable = true;
      qemu = lib.mkIf cfg.libvirt.qemu {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [pkgs.OVMF.fd];
        };
      };
    };

    # ==================== WAYDROID CONFIGURATION ====================
    virtualisation.waydroid.enable = cfg.waydroid.enable;

    # ==================== NETWORKING CONFIGURATION ====================
    networking = lib.mkIf cfg.networking.enable {
      # Enable IP forwarding for containers
      firewall = {
        # Open ports commonly used by containers
        interfaces."podman+" = lib.mkIf cfg.podman.enable {
          allowedUDPPorts = [ 53 ];
          allowedTCPPorts = [ 53 ];
        };
        
        interfaces."docker+" = lib.mkIf cfg.docker.enable {
          allowedUDPPorts = [ 53 ];
          allowedTCPPorts = [ 53 ];
        };
      };
    };

    # ==================== SYSTEM PACKAGES ====================
    environment.systemPackages = with pkgs;
      []
      ++ lib.optionals cfg.podman.enable ([
        podman
        conmon
        runc
        fuse-overlayfs
        slirp4netns
      ] ++ cfg.podman.extraPackages)
      ++ lib.optionals cfg.docker.enable [
        docker
        docker-compose
      ]
      ++ lib.optionals cfg.libvirt.enable [
        virt-manager
        virt-viewer
        spice
        spice-gtk
        spice-protocol
        virtio-win
      ]
      ++ lib.optionals cfg.waydroid.enable [
        waydroid
      ]
      ++ lib.optionals cfg.networking.slirp4netns [
        slirp4netns
      ];

    # ==================== USER GROUPS ====================
    users.users.${username} = {
      extraGroups =
        []
        ++ lib.optionals cfg.podman.enable ["podman"]
        ++ lib.optionals cfg.docker.enable ["docker"]
        ++ lib.optionals cfg.libvirt.enable ["libvirtd" "kvm"]
        ++ lib.optionals cfg.waydroid.enable ["users"]; # Waydroid typically needs users group
    };

    # ==================== ADDITIONAL SERVICES ====================
    services = {
      # Enable spice-vdagentd for better VM integration
      spice-vdagentd.enable = lib.mkIf cfg.libvirt.enable true;
      
      # Enable dbus for container management
      dbus.enable = true;
    };

    # ==================== KERNEL MODULES ====================
    boot = {
      # Load required kernel modules
      kernelModules = 
        []
        ++ lib.optionals cfg.libvirt.enable ["kvm-amd"]
        ++ lib.optionals cfg.waydroid.enable ["binder_linux" "ashmem_linux"];
      
      # Kernel parameters for virtualization
      kernelParams = lib.optionals cfg.libvirt.enable [
        "amd_iommu=on"
        "iommu=pt"
      ];
    };

    # ==================== SECURITY SETTINGS ====================
    security = {
      # Enable unprivileged user namespaces for rootless containers
      unprivilegedUsernsClone = lib.mkIf (cfg.podman.enable || cfg.docker.rootless) true;
      
      # Polkit rules for libvirt
      polkit.enable = lib.mkIf cfg.libvirt.enable true;
    };

    # ==================== ENVIRONMENT VARIABLES ====================
    environment.variables = lib.mkMerge [
      # Podman environment
      (lib.mkIf cfg.podman.enable {
        PODMAN_COMPOSE_WARNING_LOGS = "false";
      })
      
      # Docker environment for rootless
      (lib.mkIf (cfg.docker.enable && cfg.docker.rootless) {
        DOCKER_HOST = "unix:///run/user/1000/docker.sock";
      })
    ];

    # ==================== SYSTEMD SERVICES ====================
    systemd = {
      # Podman auto-update service
      services.podman-auto-update = lib.mkIf cfg.podman.enable {
        description = "Podman auto-update service";
        wants = ["network-online.target"];
        after = ["network-online.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.podman}/bin/podman auto-update";
          User = username;
        };
      };

      # Podman auto-update timer
      timers.podman-auto-update = lib.mkIf cfg.podman.enable {
        description = "Podman auto-update timer";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
    };
  };
}