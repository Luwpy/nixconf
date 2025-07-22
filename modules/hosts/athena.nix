{
  inputs,
  modulesPath,
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    inputs.nixos-facter.nixosModules.facter
    { config.facter.reportPath = ../../facter.athena.json; }

    ../home
    ../nixos/system.nix

    ../nixos/disko
    ../nixos/sops.nix
    ../nixos/niri.nix
    ../nixos/hyprland.nix
    ../nixos/stylix.nix
    ../nixos/virtualisation.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ==================== NETWORKING ====================
  networking = {
    hostName = "athena";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };

    # Network optimizations for gaming/streaming
  };

  # ==================== LOCALE & TIME ====================
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  # ==================== AMD BOOT OPTIMIZATIONS ====================
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 3; # Quick boot
    };

    # Keep your zen kernel but add AMD optimizations
    kernelPackages = pkgs.linuxPackages_zen;

    # AMD-specific kernel parameters
    kernelParams = [
      "amdgpu.dc=1" # Display Core for modern features
      "amdgpu.gpu_recovery=1" # GPU recovery on crashes
      "amd_pstate=active" # Modern AMD P-State driver for Ryzen 5600
    ];

    # Essential kernel modules for your hardware
    kernelModules = [
      "amdgpu" # AMD GPU driver
      "kvm-amd" # Virtualization support for Ryzen
    ];

    # Load AMD GPU drivers early in boot
    initrd.kernelModules = [ "amdgpu" ];

    # Performance optimizations
    kernel.sysctl = {
      # Virtual memory optimizations for gaming/desktop
      "vm.swappiness" = 10; # Prefer RAM over swap
      "vm.dirty_ratio" = 15; # Dirty page cache ratio
      "vm.dirty_background_ratio" = 5; # Background dirty page ratio
    };

    supportedFilesystems = [ "ntfs" ];
  };

  # ==================== AMD HARDWARE CONFIGURATION ====================
  hardware = {
    # AMD CPU microcode updates for Ryzen 5600
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    # Enhanced graphics configuration for RX 7600
    graphics = {
      enable = true;
      enable32Bit = true;

      # AMD-specific packages for RX 7600
      extraPackages = with pkgs; [
        amdvlk # AMD's official Vulkan driver
        libva # Video Acceleration API
        libva-utils # VA-API utilities
      ];

      # 32-bit support for games
      extraPackages32 = with pkgs.pkgsi686Linux; [
        amdvlk
      ];
    };

    # Firmware support
    enableRedistributableFirmware = true;

    # Bluetooth configuration
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true; # Better device support
        };
      };
    };
  };

  # ==================== SERVICES ====================
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    # Enhanced PipeWire configuration
    pipewire = {
      enable = true;
      audio.enable = true; # Add this for proper audio
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true; # Enable JACK for pro audio
      wireplumber.enable = true; # Modern session manager
    };

    printing.enable = true;

    # Additional services for your AMD setup
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ]; # Explicit AMD driver
    };

    # Hardware monitoring and management
    smartd.enable = true; # Monitor disk health
    fwupd.enable = true; # Firmware updates
    blueman.enable = true; # Bluetooth manager GUI

    # Power management optimized for Ryzen
    # power-profiles-daemon.enable = true;
    auto-cpufreq.enable = true; # Automatic CPU frequency scaling
  };

  # ==================== POWER MANAGEMENT ====================
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "schedutil"; # Best for Ryzen 5600
  };

  # ==================== PERFORMANCE & GAMING ====================
  programs.gamemode.enable = true; # Automatic game optimizations

  # Security optimizations for real-time applications
  security = {
    rtkit.enable = true;
    pam.loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        type = "-";
        value = "1";
      }
    ];
  };

  # ==================== USER CONFIGURATION ====================
  users.users.${username} = {
    openssh.authorizedKeys.keys = [ ];
    shell = pkgs.zsh;

    extraGroups = [
      "audio"
      "video"
      "input" # Input devices (keyboards, mice)
      "render" # GPU rendering access
      "gamemode" # GameMode optimizations
      "podman"
      "wheel"
      "networkmanager"
    ];
  };

  programs.zsh.enable = true;

  # ==================== MODULES ====================
  modules.home = {
    enable = true;
    modules = [
      # Add these as you create them:
      ../home/git.nix
      ../home/fish.nix
      ../home/eza.nix
      ../home/hyprland.nix
      ../home/zed.nix
      ../home/zen-browser.nix
    ];

    packages = with pkgs; [
      # Your current packages
      zed-editor
      discord
      vesktop
      spotify
      revolt-desktop
      vscode

      ripgrep
      fd
      bat
      eza
      zoxide

      # Additional AMD/graphics tools
      kitty # GPU-accelerated terminal
      firefox # Web browser
      vlc # Media player

      # GPU monitoring and tools
      radeontop # AMD GPU monitoring
      amdgpu_top # Modern AMD GPU monitor
      # nvtop # System GPU monitor (works with AMD)
      btop # System monitor

      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  modules.disko = {
    enable = true;
    device = "/dev/disk/by-id/ata-S3SSDA480_S3+4802104290073";
    fileSystem = "athena";
    swapSizeInGb = "16G";
  };

  modules.sops.enable = true;

  modules.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  modules.virtualisation = {
    enable = true;

    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket = true;
      extraPackages = with pkgs; [
        podman-compose
        podman-tui
      ];
    };

    libvirt = {
      enable = true;
      qemu = true;
    };

    networking = {
      enable = true;
      slirp4netns = true;
    };
  };

  # ==================== SYSTEM PACKAGES ====================
  environment = {
    # AMD-specific environment variables
    variables = {
      AMD_VULKAN_ICD = "RADV"; # Use Mesa RADV Vulkan driver
      LIBVA_DRIVER_NAME = "radeonsi"; # Hardware video acceleration
    };

    systemPackages = with pkgs; [
      # Your current packages
      pciutils
      usbutils
      lshw

      networkmanager
      networkmanagerapplet

      p7zip
      unrar

      # AMD-specific tools
      glxinfo # OpenGL information
      vulkan-tools # Vulkan utilities (vulkaninfo, etc.)
      mesa-demos # OpenGL demos and tests

      # Audio tools
      pavucontrol # PulseAudio/PipeWire volume control
      helvum # PipeWire patchbay
      pamixer # CLI audio mixer

      # Hardware monitoring
      lm_sensors # Hardware sensors
      inxi # Detailed system information
      neofetch # System info display

      # Performance tools
      htop
      iotop # I/O monitoring
    ];
  };

  # ==================== NIXPKGS CONFIGURATION ====================
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "x86_64-linux";
}
